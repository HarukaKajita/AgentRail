param(
  [string]$ProfilePath = "project.profile.yaml",
  [string]$SchemaPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
  param([string]$Reason)
  $failures.Add($Reason)
}

function Write-ValidationResult {
  param([int]$ExitCode)

  if ($failures.Count -eq 0) {
    Write-Output "PROFILE_VALIDATE: PASS"
    Write-Output "Validated profile: $ProfilePath"
    exit 0
  }

  Write-Output "PROFILE_VALIDATE: FAIL"
  Write-Output "Failure Count: $($failures.Count)"
  foreach ($failure in $failures) {
    Write-Output "- $failure"
  }
  exit $ExitCode
}

function Get-RequiredKeyPattern {
  param(
    [string]$Path,
    [string]$ValueType
  )

  if ([string]::IsNullOrWhiteSpace($Path)) {
    return ""
  }

  $segments = @($Path.Split("."))
  if ($segments.Count -eq 0) {
    return ""
  }

  $builder = New-Object System.Text.StringBuilder
  # Build nested-key regex from dotted key path and 2-space YAML indentation.
  [void]$builder.Append("(?m)")

  for ($index = 0; $index -lt $segments.Count; $index++) {
    $segment = [string]$segments[$index]
    if ([string]::IsNullOrWhiteSpace($segment)) {
      return ""
    }

    $indent = " " * ($index * 2)
    $escapedSegment = [Regex]::Escape($segment.Trim())
    $isLast = $index -eq ($segments.Count - 1)

    if ($isLast) {
      if ($ValueType -eq "container") {
        [void]$builder.Append("^${indent}${escapedSegment}:\s*$")
      } else {
        [void]$builder.Append("^${indent}${escapedSegment}:\s*\S+")
      }
      continue
    }

    [void]$builder.Append("^${indent}${escapedSegment}:\s*$[\s\S]*?")
  }

  return $builder.ToString()
}

function Get-TopLevelScalarValue {
  param(
    [string]$Content,
    [string]$Key
  )

  if ([string]::IsNullOrWhiteSpace($Content) -or [string]::IsNullOrWhiteSpace($Key)) {
    return ""
  }

  $escapedKey = [Regex]::Escape($Key)
  $match = [Regex]::Match($Content, "(?m)^${escapedKey}:\s*(.+?)\s*$")
  if (-not $match.Success) {
    return ""
  }

  $rawValue = [string]$match.Groups[1].Value.Trim()
  if ($rawValue.Length -ge 2 -and $rawValue.StartsWith('"') -and $rawValue.EndsWith('"')) {
    return $rawValue.Substring(1, $rawValue.Length - 2)
  }

  if ($rawValue.Length -ge 2 -and $rawValue.StartsWith("'") -and $rawValue.EndsWith("'")) {
    return $rawValue.Substring(1, $rawValue.Length - 2)
  }

  return $rawValue
}

if (-not (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
  Add-Failure "Profile file does not exist: $ProfilePath"
  Write-ValidationResult -ExitCode 1
}

$resolvedSchemaPath = if ([string]::IsNullOrWhiteSpace($SchemaPath)) {
  Join-Path -Path $PSScriptRoot -ChildPath "profile-schema.json"
} else {
  $SchemaPath
}

if (-not (Test-Path -LiteralPath $resolvedSchemaPath -PathType Leaf)) {
  Add-Failure "Profile schema file does not exist: $resolvedSchemaPath"
  Write-ValidationResult -ExitCode 1
}

$profileContent = Get-Content -LiteralPath $ProfilePath -Raw
$schema = $null
try {
  $schema = Get-Content -LiteralPath $resolvedSchemaPath -Raw | ConvertFrom-Json
} catch {
  Add-Failure "Profile schema is not valid JSON: $resolvedSchemaPath"
  Write-ValidationResult -ExitCode 1
}

$forbiddenPlaceholders = @("TODO_SET_ME")
if ($schema -and $schema.PSObject.Properties.Name -contains "forbidden_placeholders") {
  $configuredPlaceholders = @($schema.forbidden_placeholders | ForEach-Object { [string]$_ })
  if ($configuredPlaceholders.Count -gt 0) {
    $forbiddenPlaceholders = $configuredPlaceholders
  }
}

foreach ($placeholder in $forbiddenPlaceholders) {
  if ([string]::IsNullOrWhiteSpace($placeholder)) {
    continue
  }

  if ($profileContent.Contains($placeholder)) {
    Add-Failure "Forbidden placeholder remains: $placeholder"
  }
}

$requiredKeys = @()
if ($schema -and $schema.PSObject.Properties.Name -contains "required_keys") {
  $requiredKeys = @($schema.required_keys)
} else {
  Add-Failure "Profile schema is missing required_keys: $resolvedSchemaPath"
}

if ($requiredKeys.Count -eq 0) {
  Add-Failure "Profile schema contains no required_keys entries: $resolvedSchemaPath"
}

$allowedValueTypes = @("scalar", "container")
foreach ($requiredKey in $requiredKeys) {
  if ($null -eq $requiredKey) {
    Add-Failure "Invalid required_keys entry: null"
    continue
  }

  $hasPath = $requiredKey.PSObject.Properties.Name -contains "path"
  if (-not $hasPath -or [string]::IsNullOrWhiteSpace([string]$requiredKey.path)) {
    Add-Failure "Invalid required_keys entry: path is missing or empty."
    continue
  }

  $path = [string]$requiredKey.path
  $valueType = "scalar"
  if ($requiredKey.PSObject.Properties.Name -contains "value_type" -and -not [string]::IsNullOrWhiteSpace([string]$requiredKey.value_type)) {
    $valueType = [string]$requiredKey.value_type
  }
  $valueType = $valueType.ToLowerInvariant()

  if ($valueType -notin $allowedValueTypes) {
    Add-Failure "Invalid value_type '$valueType' for required key path: $path"
    continue
  }

  $pattern = Get-RequiredKeyPattern -Path $path -ValueType $valueType
  if ([string]::IsNullOrWhiteSpace($pattern)) {
    Add-Failure "Failed to build validation pattern for required key path: $path"
    continue
  }

  if (-not [Regex]::IsMatch($profileContent, $pattern)) {
    Add-Failure "Missing required key path: $path"
  }
}

$supportedProfileSchemaVersions = @()
if ($schema -and $schema.PSObject.Properties.Name -contains "supported_profile_schema_versions") {
  $supportedProfileSchemaVersions = @($schema.supported_profile_schema_versions | ForEach-Object { [string]$_ })
} else {
  Add-Failure "Profile schema is missing supported_profile_schema_versions: $resolvedSchemaPath"
}

if ($supportedProfileSchemaVersions.Count -eq 0) {
  Add-Failure "Profile schema contains no supported_profile_schema_versions entries: $resolvedSchemaPath"
} else {
  $profileSchemaVersion = Get-TopLevelScalarValue -Content $profileContent -Key "schema_version"
  if ([string]::IsNullOrWhiteSpace($profileSchemaVersion)) {
    Add-Failure "schema_version is missing or blank."
  } elseif ($profileSchemaVersion -notin $supportedProfileSchemaVersions) {
    Add-Failure "Unsupported schema_version '$profileSchemaVersion'. Supported: $($supportedProfileSchemaVersions -join ', ')"
  }
}

Write-ValidationResult -ExitCode 1
