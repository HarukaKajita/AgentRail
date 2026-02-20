param(
  [string]$RepoRoot = ".",
  [string]$SchemaPath = "tools/profile-validate/profile-schema.json",
  [string]$BaseSha = "",
  [string]$HeadSha = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[object]

function Add-Failure {
  param(
    [string]$RuleId,
    [string]$Reason
  )

  $failures.Add([PSCustomObject]@{
      rule_id = $RuleId
      reason  = $Reason
    })
}

function Normalize-PathString {
  param([string]$PathValue)

  if ([string]::IsNullOrWhiteSpace($PathValue)) {
    return ""
  }

  return $PathValue.Trim().Replace("\", "/")
}

function Get-ResolvedHeadSha {
  param(
    [string]$Root,
    [string]$Head
  )

  if (-not [string]::IsNullOrWhiteSpace($Head)) {
    $resolvedFromInput = (& git -C $Root rev-parse $Head.Trim() 2>$null).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($resolvedFromInput)) {
      Add-Failure -RuleId "R-001" -Reason "Failed to resolve HeadSha: $Head"
      return ""
    }

    return $resolvedFromInput
  }

  $resolvedHead = (& git -C $Root rev-parse HEAD).Trim()
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($resolvedHead)) {
    Add-Failure -RuleId "R-001" -Reason "Failed to resolve HEAD SHA."
    return ""
  }

  return $resolvedHead
}

function Get-RepoRelativePath {
  param(
    [string]$Root,
    [string]$PathValue
  )

  $repoFullPath = [System.IO.Path]::GetFullPath($Root)
  $inputFullPath = if ([System.IO.Path]::IsPathRooted($PathValue)) {
    [System.IO.Path]::GetFullPath($PathValue)
  } else {
    [System.IO.Path]::GetFullPath((Join-Path -Path $Root -ChildPath $PathValue))
  }

  if (-not $inputFullPath.StartsWith($repoFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
    Add-Failure -RuleId "R-001" -Reason "SchemaPath must be under repo root: $PathValue"
    return ""
  }

  $relative = $inputFullPath.Substring($repoFullPath.Length).TrimStart('\', '/')
  return Normalize-PathString -PathValue $relative
}

function Test-SchemaChanged {
  param(
    [string]$Root,
    [string]$Base,
    [string]$Head,
    [string]$RelativePath
  )

  $isBaseMissing = [string]::IsNullOrWhiteSpace($Base) -or ($Base -eq "0000000000000000000000000000000000000000")
  if ($isBaseMissing) {
    $pathChanges = & git -C $Root diff-tree --no-commit-id --name-only -r --root "$Head" -- "$RelativePath"
    if ($LASTEXITCODE -ne 0) {
      Add-Failure -RuleId "R-001" -Reason "Failed to collect schema file change state from head commit: $Head"
      return $false
    }

    return @($pathChanges).Count -gt 0
  }

  & git -C $Root diff --quiet "$Base...$Head" -- "$RelativePath"
  if ($LASTEXITCODE -eq 0) {
    return $false
  }
  if ($LASTEXITCODE -eq 1) {
    return $true
  }

  Add-Failure -RuleId "R-001" -Reason "Failed to evaluate schema file change state between base/head: $Base...$Head"
  return $false
}

function Get-FileContentAtRef {
  param(
    [string]$Root,
    [string]$Ref,
    [string]$RelativePath
  )

  if ([string]::IsNullOrWhiteSpace($Ref)) {
    return $null
  }

  $refSpec = "${Ref}:$RelativePath"
  $content = & git -C $Root show $refSpec 2>$null
  if ($LASTEXITCODE -ne 0) {
    return $null
  }

  return [string]($content -join [Environment]::NewLine)
}

function Get-JsonAtRef {
  param(
    [string]$Root,
    [string]$Ref,
    [string]$RelativePath,
    [string]$RuleId,
    [string]$Label
  )

  $content = Get-FileContentAtRef -Root $Root -Ref $Ref -RelativePath $RelativePath
  if ($null -eq $content) {
    Add-Failure -RuleId $RuleId -Reason "Schema file is not available at $Label ref: $Ref"
    return $null
  }

  try {
    return $content | ConvertFrom-Json
  } catch {
    Add-Failure -RuleId $RuleId -Reason "Schema file is not valid JSON at $Label ref: $Ref"
    return $null
  }
}

function Get-StringArrayProperty {
  param(
    [object]$Object,
    [string]$PropertyName,
    [string]$RuleId,
    [string]$Label
  )

  if ($null -eq $Object -or -not ($Object.PSObject.Properties.Name -contains $PropertyName)) {
    Add-Failure -RuleId $RuleId -Reason "Missing property '$PropertyName' in $Label schema."
    return @()
  }

  if ($null -eq $Object.$PropertyName) {
    Add-Failure -RuleId $RuleId -Reason "Property '$PropertyName' is null in $Label schema."
    return @()
  }

  $uniqueValues = New-Object System.Collections.Generic.HashSet[string]
  foreach ($rawValue in @($Object.$PropertyName)) {
    $value = [string]$rawValue
    if ([string]::IsNullOrWhiteSpace($value)) {
      continue
    }
    [void]$uniqueValues.Add($value.Trim())
  }

  return @($uniqueValues | Sort-Object)
}

function Get-RequiredKeySignatures {
  param(
    [object]$Schema,
    [string]$RuleId,
    [string]$Label
  )

  if ($null -eq $Schema -or -not ($Schema.PSObject.Properties.Name -contains "required_keys")) {
    Add-Failure -RuleId $RuleId -Reason "Missing property 'required_keys' in $Label schema."
    return @()
  }

  $signatures = New-Object System.Collections.Generic.HashSet[string]
  foreach ($rawEntry in @($Schema.required_keys)) {
    if ($null -eq $rawEntry) {
      Add-Failure -RuleId $RuleId -Reason "required_keys contains null entry in $Label schema."
      continue
    }

    $path = ""
    if ($rawEntry.PSObject.Properties.Name -contains "path") {
      $path = [string]$rawEntry.path
    }
    $valueType = ""
    if ($rawEntry.PSObject.Properties.Name -contains "value_type") {
      $valueType = [string]$rawEntry.value_type
    }

    $normalizedPath = $path.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedPath)) {
      Add-Failure -RuleId $RuleId -Reason "required_keys contains empty path in $Label schema."
      continue
    }

    $signature = "$normalizedPath|$valueType".ToLowerInvariant()
    [void]$signatures.Add($signature)
  }

  return @($signatures | Sort-Object)
}

function Get-SemVerInfo {
  param(
    [string]$VersionValue,
    [string]$RuleId,
    [string]$Label
  )

  if ([string]::IsNullOrWhiteSpace($VersionValue)) {
    Add-Failure -RuleId $RuleId -Reason "$Label schema_version is missing or blank."
    return $null
  }

  $match = [Regex]::Match($VersionValue, '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$')
  if (-not $match.Success) {
    Add-Failure -RuleId $RuleId -Reason "$Label schema_version '$VersionValue' is not SemVer (major.minor.patch)."
    return $null
  }

  return [PSCustomObject]@{
    raw   = $VersionValue
    major = [int]$match.Groups[1].Value
    minor = [int]$match.Groups[2].Value
    patch = [int]$match.Groups[3].Value
  }
}

function Test-StringArrayEquals {
  param(
    [string[]]$Left,
    [string[]]$Right
  )

  $leftValues = @($Left | Sort-Object)
  $rightValues = @($Right | Sort-Object)
  if ($leftValues.Count -ne $rightValues.Count) {
    return $false
  }

  for ($index = 0; $index -lt $leftValues.Count; $index++) {
    if ($leftValues[$index] -ne $rightValues[$index]) {
      return $false
    }
  }

  return $true
}

function Get-RemovedValues {
  param(
    [string[]]$BaseValues,
    [string[]]$HeadValues
  )

  $headSet = New-Object System.Collections.Generic.HashSet[string]
  foreach ($value in $HeadValues) {
    [void]$headSet.Add($value)
  }

  $removed = New-Object System.Collections.Generic.List[string]
  foreach ($value in $BaseValues) {
    if (-not $headSet.Contains($value)) {
      $removed.Add($value) | Out-Null
    }
  }

  return @($removed | Sort-Object)
}

function Write-Result {
  param(
    [string]$SchemaRelativePath,
    [string]$ResolvedBaseSha,
    [string]$ResolvedHeadSha,
    [bool]$SchemaChanged,
    [bool]$BreakingChange
  )

  if ($failures.Count -eq 0) {
    Write-Output "SCHEMA_GOVERNANCE: PASS"
    Write-Output "Schema path: $SchemaRelativePath"
    Write-Output "Head SHA: $ResolvedHeadSha"
    if ([string]::IsNullOrWhiteSpace($ResolvedBaseSha)) {
      Write-Output "Base SHA: <none>"
    } else {
      Write-Output "Base SHA: $ResolvedBaseSha"
    }
    Write-Output "Schema changed: $SchemaChanged"
    Write-Output "Breaking change: $BreakingChange"
    exit 0
  }

  Write-Output "SCHEMA_GOVERNANCE: FAIL"
  Write-Output "Failure Count: $($failures.Count)"
  foreach ($failure in $failures) {
    Write-Output "- rule_id=$($failure.rule_id); reason=$($failure.reason)"
  }
  exit 1
}

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
  Add-Failure -RuleId "R-001" -Reason "Repo root does not exist: $RepoRoot"
  Write-Result -SchemaRelativePath $SchemaPath -ResolvedBaseSha $BaseSha -ResolvedHeadSha $HeadSha -SchemaChanged $false -BreakingChange $false
}

$schemaRelativePath = Get-RepoRelativePath -Root $RepoRoot -PathValue $SchemaPath
$resolvedHeadSha = Get-ResolvedHeadSha -Root $RepoRoot -Head $HeadSha
$resolvedBaseSha = $BaseSha

$schemaChanged = $false
if (-not [string]::IsNullOrWhiteSpace($schemaRelativePath)) {
  $schemaChanged = Test-SchemaChanged -Root $RepoRoot -Base $resolvedBaseSha -Head $resolvedHeadSha -RelativePath $schemaRelativePath
}

$headSchema = Get-JsonAtRef -Root $RepoRoot -Ref $resolvedHeadSha -RelativePath $schemaRelativePath -RuleId "R-003" -Label "head"

$headSchemaVersion = ""
if ($headSchema -and $headSchema.PSObject.Properties.Name -contains "schema_version") {
  $headSchemaVersion = [string]$headSchema.schema_version
} else {
  Add-Failure -RuleId "R-002" -Reason "Missing property 'schema_version' in head schema."
}

$headSemVer = Get-SemVerInfo -VersionValue $headSchemaVersion -RuleId "R-002" -Label "head"
$headSupportedVersions = @(Get-StringArrayProperty -Object $headSchema -PropertyName "supported_profile_schema_versions" -RuleId "R-003" -Label "head")
if (-not [string]::IsNullOrWhiteSpace($headSchemaVersion) -and $headSupportedVersions.Count -gt 0) {
  if ($headSchemaVersion -notin $headSupportedVersions) {
    Add-Failure -RuleId "R-003" -Reason "Head schema_version '$headSchemaVersion' is not included in supported_profile_schema_versions."
  }
}

$breakingChange = $false
if ($schemaChanged) {
  $isBaseMissing = [string]::IsNullOrWhiteSpace($resolvedBaseSha) -or ($resolvedBaseSha -eq "0000000000000000000000000000000000000000")
  if ($isBaseMissing) {
    $fallbackBase = (& git -C $RepoRoot rev-parse "${resolvedHeadSha}^" 2>$null).Trim()
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($fallbackBase)) {
      $resolvedBaseSha = $fallbackBase
    }
  }

  if ([string]::IsNullOrWhiteSpace($resolvedBaseSha) -or ($resolvedBaseSha -eq "0000000000000000000000000000000000000000")) {
    Write-Output "schema-governance: BaseSha unavailable; skipping base/head schema diff checks for this run."
  } else {
    $baseSchema = Get-JsonAtRef -Root $RepoRoot -Ref $resolvedBaseSha -RelativePath $schemaRelativePath -RuleId "R-001" -Label "base"
    if ($null -ne $baseSchema -and $null -ne $headSchema) {
      $baseSchemaVersion = ""
      if ($baseSchema.PSObject.Properties.Name -contains "schema_version") {
        $baseSchemaVersion = [string]$baseSchema.schema_version
      } else {
        Add-Failure -RuleId "R-001" -Reason "Missing property 'schema_version' in base schema."
      }

      if (-not [string]::IsNullOrWhiteSpace($baseSchemaVersion) -and -not [string]::IsNullOrWhiteSpace($headSchemaVersion)) {
        if ($baseSchemaVersion -eq $headSchemaVersion) {
          Add-Failure -RuleId "R-001" -Reason "Schema file changed but schema_version is unchanged: $headSchemaVersion"
        }
      }

      $breakingReasons = New-Object System.Collections.Generic.List[string]

      $baseSchemaId = if ($baseSchema.PSObject.Properties.Name -contains "schema_id") { [string]$baseSchema.schema_id } else { "" }
      $headSchemaId = if ($headSchema.PSObject.Properties.Name -contains "schema_id") { [string]$headSchema.schema_id } else { "" }
      if ($baseSchemaId -ne $headSchemaId) {
        $breakingReasons.Add("schema_id changed") | Out-Null
      }

      $baseRequiredKeys = @(Get-RequiredKeySignatures -Schema $baseSchema -RuleId "R-004" -Label "base")
      $headRequiredKeys = @(Get-RequiredKeySignatures -Schema $headSchema -RuleId "R-004" -Label "head")
      if (-not (Test-StringArrayEquals -Left $baseRequiredKeys -Right $headRequiredKeys)) {
        $breakingReasons.Add("required_keys changed") | Out-Null
      }

      $baseForbiddenKeys = @(Get-StringArrayProperty -Object $baseSchema -PropertyName "forbidden_top_level_keys" -RuleId "R-004" -Label "base")
      $headForbiddenKeys = @(Get-StringArrayProperty -Object $headSchema -PropertyName "forbidden_top_level_keys" -RuleId "R-004" -Label "head")
      if (-not (Test-StringArrayEquals -Left $baseForbiddenKeys -Right $headForbiddenKeys)) {
        $breakingReasons.Add("forbidden_top_level_keys changed") | Out-Null
      }

      $baseSupportedVersions = @(Get-StringArrayProperty -Object $baseSchema -PropertyName "supported_profile_schema_versions" -RuleId "R-004" -Label "base")
      $removedSupportedVersions = @(Get-RemovedValues -BaseValues $baseSupportedVersions -HeadValues $headSupportedVersions)
      if ($removedSupportedVersions.Count -gt 0) {
        $breakingReasons.Add("supported_profile_schema_versions removed: $($removedSupportedVersions -join ', ')") | Out-Null
      }

      if ($breakingReasons.Count -gt 0) {
        $breakingChange = $true
        $baseSemVer = Get-SemVerInfo -VersionValue $baseSchemaVersion -RuleId "R-004" -Label "base"
        if ($null -ne $baseSemVer -and $null -ne $headSemVer) {
          if ($headSemVer.major -le $baseSemVer.major) {
            Add-Failure -RuleId "R-004" -Reason "Breaking change requires major version increment. base=$baseSchemaVersion, head=$headSchemaVersion, reasons=$($breakingReasons -join '; ')"
          }
        }
      }
    }
  }
}

Write-Result -SchemaRelativePath $schemaRelativePath -ResolvedBaseSha $resolvedBaseSha -ResolvedHeadSha $resolvedHeadSha -SchemaChanged $schemaChanged -BreakingChange $breakingChange
