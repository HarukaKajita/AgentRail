param(
  [ValidateSet("apply", "check")]
  [string]$Mode = "apply",
  [string]$ManifestPath = "framework.runtime.manifest.yaml",
  [string]$OutputRoot = "",
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([string]$Message)
  Write-Error "runtime-export: $Message"
  exit 1
}

function Normalize-RelativePath {
  param([string]$Value)

  $normalized = $Value.Replace("\", "/").Trim()
  while ($normalized.StartsWith("./")) {
    $normalized = $normalized.Substring(2)
  }
  while ($normalized.StartsWith("/")) {
    $normalized = $normalized.Substring(1)
  }
  while ($normalized.EndsWith("/")) {
    $normalized = $normalized.Substring(0, $normalized.Length - 1)
  }

  return $normalized
}

function Remove-WrappingQuotes {
  param([string]$Value)

  $trimmed = $Value.Trim()
  if ($trimmed.Length -ge 2) {
    if (($trimmed.StartsWith('"') -and $trimmed.EndsWith('"')) -or ($trimmed.StartsWith("'") -and $trimmed.EndsWith("'"))) {
      return $trimmed.Substring(1, $trimmed.Length - 2)
    }
  }

  return $trimmed
}

function Parse-Manifest {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Fail("Manifest file not found: $Path")
  }

  $allowedScalarKeys = @("schema_version", "output_root")
  $allowedListKeys = @("include_paths", "seed_files", "exclude_paths", "exclude_globs")
  $allowedKeys = @($allowedScalarKeys + $allowedListKeys)

  $manifest = [ordered]@{
    schema_version = ""
    output_root    = ""
    include_paths  = New-Object System.Collections.Generic.List[string]
    seed_files     = New-Object System.Collections.Generic.List[string]
    exclude_paths  = New-Object System.Collections.Generic.List[string]
    exclude_globs  = New-Object System.Collections.Generic.List[string]
  }

  $currentListKey = ""
  $lineNumber = 0
  $lines = Get-Content -LiteralPath $Path
  foreach ($rawLine in $lines) {
    $lineNumber++
    $line = [string]$rawLine
    if ([string]::IsNullOrWhiteSpace($line)) {
      continue
    }

    $trimmedStart = $line.TrimStart()
    if ($trimmedStart.StartsWith("#")) {
      continue
    }

    $listItemMatch = [Regex]::Match($line, '^\s*-\s+(.+?)\s*$')
    if ($listItemMatch.Success) {
      if ([string]::IsNullOrWhiteSpace($currentListKey)) {
        Fail("Manifest parse error at line ${lineNumber}: list item found without active list key.")
      }

      $value = Remove-WrappingQuotes -Value $listItemMatch.Groups[1].Value
      if ([string]::IsNullOrWhiteSpace($value)) {
        Fail("Manifest parse error at line ${lineNumber}: list item must not be empty.")
      }
      $manifest[$currentListKey].Add($value) | Out-Null
      continue
    }

    $keyValueMatch = [Regex]::Match($line, '^([A-Za-z0-9_]+)\s*:\s*(.*?)\s*$')
    if (-not $keyValueMatch.Success) {
      Fail("Manifest parse error at line ${lineNumber}: invalid syntax.")
    }

    $key = $keyValueMatch.Groups[1].Value.ToLowerInvariant()
    $valueRaw = $keyValueMatch.Groups[2].Value

    if ($allowedKeys -notcontains $key) {
      Fail("Manifest parse error at line ${lineNumber}: unknown key '$key'.")
    }

    if ($allowedListKeys -contains $key) {
      if ([string]::IsNullOrWhiteSpace($valueRaw)) {
        $currentListKey = $key
        continue
      }
      Fail("Manifest parse error at line ${lineNumber}: list key '$key' must not have inline value.")
    }

    $currentListKey = ""
    $manifest[$key] = Remove-WrappingQuotes -Value $valueRaw
  }

  if ([string]::IsNullOrWhiteSpace([string]$manifest.schema_version)) {
    Fail("Manifest validation error: schema_version is required.")
  }
  if ([string]::IsNullOrWhiteSpace([string]$manifest.output_root)) {
    Fail("Manifest validation error: output_root is required.")
  }
  if ($manifest.include_paths.Count -eq 0) {
    Fail("Manifest validation error: include_paths must contain at least one entry.")
  }

  return [PSCustomObject]@{
    schema_version = [string]$manifest.schema_version
    output_root    = Normalize-RelativePath -Value ([string]$manifest.output_root)
    include_paths  = @($manifest.include_paths)
    seed_files     = @($manifest.seed_files)
    exclude_paths  = @($manifest.exclude_paths | ForEach-Object { Normalize-RelativePath -Value $_ })
    exclude_globs  = @($manifest.exclude_globs | ForEach-Object { Normalize-RelativePath -Value $_ })
  }
}

function Parse-SeedMappings {
  param(
    [string[]]$Entries
  )

  $result = New-Object System.Collections.Generic.List[object]
  foreach ($entryRaw in $Entries) {
    $entry = [string]$entryRaw
    $mappingMatch = [Regex]::Match($entry, '^\s*(.+?)\s*=>\s*(.+?)\s*$')
    if (-not $mappingMatch.Success) {
      Fail("Manifest validation error: seed_files entry must use '<source> => <destination>' format. Entry: $entry")
    }

    $source = Normalize-RelativePath -Value (Remove-WrappingQuotes -Value $mappingMatch.Groups[1].Value)
    $destination = Normalize-RelativePath -Value (Remove-WrappingQuotes -Value $mappingMatch.Groups[2].Value)
    if ([string]::IsNullOrWhiteSpace($source) -or [string]::IsNullOrWhiteSpace($destination)) {
      Fail("Manifest validation error: seed_files entry must not have empty source or destination. Entry: $entry")
    }

    $result.Add([PSCustomObject]@{
        source      = $source
        destination = $destination
      }) | Out-Null
  }

  return $result
}

function Test-IsUnderPath {
  param(
    [string]$TargetPath,
    [string]$ParentPath
  )

  if ([string]::IsNullOrWhiteSpace($ParentPath)) {
    return $false
  }

  if ($TargetPath.Equals($ParentPath, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $true
  }

  return $TargetPath.StartsWith($ParentPath + "/", [System.StringComparison]::OrdinalIgnoreCase)
}

function Convert-GlobToRegexPattern {
  param([string]$Glob)

  $escaped = [Regex]::Escape($Glob)
  $escaped = $escaped -replace '\\\*\\\*', '__DOUBLE_STAR__'
  $escaped = $escaped -replace '\\\*', '[^/]*'
  $escaped = $escaped -replace '\\\?', '[^/]'
  $escaped = $escaped -replace '__DOUBLE_STAR__', '.*'
  return "^" + $escaped + "$"
}

function Test-GlobMatch {
  param(
    [string]$Path,
    [string]$Glob
  )

  $regexPattern = Convert-GlobToRegexPattern -Glob $Glob
  return [Regex]::IsMatch($Path, $regexPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function Resolve-FilePlan {
  param(
    [string]$RepoRoot,
    [object]$Manifest
  )

  $recordByDestination = @{}

  function Add-Record {
    param(
      [string]$SourceFullPath,
      [string]$DestinationRelativePath,
      [string]$Origin
    )

    $destination = Normalize-RelativePath -Value $DestinationRelativePath
    if ([string]::IsNullOrWhiteSpace($destination)) {
      Fail("Resolved empty destination path for source: $SourceFullPath")
    }

    if ($recordByDestination.ContainsKey($destination)) {
      $existing = $recordByDestination[$destination]
      if ($existing.source_full_path -ne $SourceFullPath) {
        if ($Origin -eq "seed") {
          # Seed files explicitly override included files.
          $recordByDestination[$destination] = [PSCustomObject]@{
            source_full_path = $SourceFullPath
            destination_path = $destination
            origin           = $Origin
          }
          return
        }

        Fail("Destination path conflict detected: $destination")
      }
      return
    }

    $recordByDestination[$destination] = [PSCustomObject]@{
      source_full_path = $SourceFullPath
      destination_path = $destination
      origin           = $Origin
    }
  }

  foreach ($includePathRaw in $Manifest.include_paths) {
    $includePath = Normalize-RelativePath -Value $includePathRaw
    if ([string]::IsNullOrWhiteSpace($includePath)) {
      Fail("Manifest validation error: include_paths must not contain empty entries.")
    }

    $fullPath = Join-Path -Path $RepoRoot -ChildPath $includePath
    if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
      Add-Record -SourceFullPath $fullPath -DestinationRelativePath $includePath -Origin "include"
      continue
    }

    if (Test-Path -LiteralPath $fullPath -PathType Container) {
      $files = Get-ChildItem -LiteralPath $fullPath -File -Recurse | Sort-Object FullName
      foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($RepoRoot, $file.FullName).Replace("\", "/")
        Add-Record -SourceFullPath $file.FullName -DestinationRelativePath $relativePath -Origin "include"
      }
      continue
    }

    Fail("Manifest validation error: include path does not exist: $includePath")
  }

  $seedMappings = Parse-SeedMappings -Entries $Manifest.seed_files
  foreach ($mapping in $seedMappings) {
    $sourceFullPath = Join-Path -Path $RepoRoot -ChildPath $mapping.source
    if (-not (Test-Path -LiteralPath $sourceFullPath -PathType Leaf)) {
      Fail("Manifest validation error: seed source file does not exist: $($mapping.source)")
    }

    Add-Record -SourceFullPath $sourceFullPath -DestinationRelativePath $mapping.destination -Origin "seed"
  }

  $excludedCount = 0
  $finalRecords = New-Object System.Collections.Generic.List[object]
  foreach ($record in $recordByDestination.Values) {
    $destinationPath = [string]$record.destination_path
    $excluded = $false

    foreach ($excludePath in $Manifest.exclude_paths) {
      if (Test-IsUnderPath -TargetPath $destinationPath -ParentPath $excludePath) {
        $excluded = $true
        break
      }
    }

    if (-not $excluded) {
      foreach ($globPattern in $Manifest.exclude_globs) {
        if (Test-GlobMatch -Path $destinationPath -Glob $globPattern) {
          $excluded = $true
          break
        }
      }
    }

    if ($excluded) {
      $excludedCount++
      continue
    }

    $finalRecords.Add($record) | Out-Null
  }

  $sorted = @($finalRecords | Sort-Object destination_path)
  return [PSCustomObject]@{
    records             = $sorted
    excluded_count      = $excludedCount
    seed_file_count     = @($sorted | Where-Object { $_.origin -eq "seed" }).Count
    include_file_count  = @($sorted | Where-Object { $_.origin -eq "include" }).Count
    total_planned_count = $sorted.Count
  }
}

function Compare-OutputWithPlan {
  param(
    [string]$OutputRootFullPath,
    [object]$Plan
  )

  if (-not (Test-Path -LiteralPath $OutputRootFullPath -PathType Container)) {
    return [PSCustomObject]@{
      missing = @($Plan.records | ForEach-Object { $_.destination_path })
      extra   = @()
      changed = @()
    }
  }

  $expectedHashByPath = @{}
  foreach ($record in $Plan.records) {
    $hash = (Get-FileHash -LiteralPath $record.source_full_path -Algorithm SHA256).Hash
    $expectedHashByPath[$record.destination_path] = $hash
  }

  $actualHashByPath = @{}
  $outputFiles = Get-ChildItem -LiteralPath $OutputRootFullPath -File -Recurse
  foreach ($file in $outputFiles) {
    $relative = [System.IO.Path]::GetRelativePath($OutputRootFullPath, $file.FullName).Replace("\", "/")
    $actualHashByPath[$relative] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
  }

  $missing = New-Object System.Collections.Generic.List[string]
  $extra = New-Object System.Collections.Generic.List[string]
  $changed = New-Object System.Collections.Generic.List[string]

  foreach ($expectedPath in ($expectedHashByPath.Keys | Sort-Object)) {
    if (-not $actualHashByPath.ContainsKey($expectedPath)) {
      $missing.Add($expectedPath) | Out-Null
      continue
    }
    if ($actualHashByPath[$expectedPath] -ne $expectedHashByPath[$expectedPath]) {
      $changed.Add($expectedPath) | Out-Null
    }
  }

  foreach ($actualPath in ($actualHashByPath.Keys | Sort-Object)) {
    if (-not $expectedHashByPath.ContainsKey($actualPath)) {
      $extra.Add($actualPath) | Out-Null
    }
  }

  return [PSCustomObject]@{
    missing = @($missing)
    extra   = @($extra)
    changed = @($changed)
  }
}

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath "../..")).Path
$manifestFullPath = if ([System.IO.Path]::IsPathRooted($ManifestPath)) {
  $ManifestPath
} else {
  Join-Path -Path $repoRoot -ChildPath $ManifestPath
}

$manifest = Parse-Manifest -Path $manifestFullPath
$resolvedOutputRoot = if ([string]::IsNullOrWhiteSpace($OutputRoot)) { $manifest.output_root } else { Normalize-RelativePath -Value $OutputRoot }
$outputRootFullPath = if ([System.IO.Path]::IsPathRooted($resolvedOutputRoot)) {
  $resolvedOutputRoot
} else {
  Join-Path -Path $repoRoot -ChildPath $resolvedOutputRoot
}

$plan = Resolve-FilePlan -RepoRoot $repoRoot -Manifest $manifest

Write-Output "runtime-export: MODE=$Mode"
Write-Output "runtime-export: manifest=$manifestFullPath"
Write-Output "runtime-export: output_root=$resolvedOutputRoot"
Write-Output "runtime-export: dry_run=$($DryRun.IsPresent)"
Write-Output "runtime-export: planned_files=$($plan.total_planned_count) (include=$($plan.include_file_count), seed=$($plan.seed_file_count), excluded=$($plan.excluded_count))"

if ($Mode -eq "apply") {
  if (-not $DryRun.IsPresent) {
    if (Test-Path -LiteralPath $outputRootFullPath -PathType Container) {
      Remove-Item -LiteralPath $outputRootFullPath -Recurse -Force
    }
    Ensure-Directory -Path $outputRootFullPath
  }

  foreach ($record in $plan.records) {
    $destinationNative = $record.destination_path.Replace("/", [System.IO.Path]::DirectorySeparatorChar)
    $destinationPath = Join-Path -Path $outputRootFullPath -ChildPath $destinationNative
    if ($DryRun.IsPresent) {
      Write-Output ("PLAN COPY: " + $record.destination_path + " <= " + (Normalize-RelativePath -Value ([System.IO.Path]::GetRelativePath($repoRoot, $record.source_full_path))))
      continue
    }

    $destinationDir = Split-Path -Parent $destinationPath
    Ensure-Directory -Path $destinationDir
    Copy-Item -LiteralPath $record.source_full_path -Destination $destinationPath -Force
  }

  if ($DryRun.IsPresent) {
    Write-Output "runtime-export: PASS (dry-run)"
    exit 0
  }

  Write-Output "runtime-export: PASS (apply)"
  exit 0
}

$comparison = Compare-OutputWithPlan -OutputRootFullPath $outputRootFullPath -Plan $plan
$missingCount = $comparison.missing.Count
$extraCount = $comparison.extra.Count
$changedCount = $comparison.changed.Count

if ($missingCount -eq 0 -and $extraCount -eq 0 -and $changedCount -eq 0) {
  Write-Output "runtime-export: PASS (check)"
  exit 0
}

Write-Output "runtime-export: FAIL (check)"
Write-Output "  missing=$missingCount"
foreach ($path in ($comparison.missing | Select-Object -First 20)) {
  Write-Output "    - $path"
}
Write-Output "  extra=$extraCount"
foreach ($path in ($comparison.extra | Select-Object -First 20)) {
  Write-Output "    + $path"
}
Write-Output "  changed=$changedCount"
foreach ($path in ($comparison.changed | Select-Object -First 20)) {
  Write-Output "    ~ $path"
}
if ($missingCount -gt 20 -or $extraCount -gt 20 -or $changedCount -gt 20) {
  Write-Output "  ... truncated to first 20 entries per category"
}
exit 1
