param(
  [Parameter(Mandatory = $true)]
  [string]$TargetRoot,
  [string]$RuntimeSource = "dist/runtime",
  [switch]$DryRun,
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([string]$Message)
  Write-Error "runtime-install: $Message"
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
  return $normalized
}

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Update-TargetProfile {
  param(
    [string]$ProfilePath,
    [switch]$DryRunMode
  )

  if (-not (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
    Fail("project.profile.yaml not found in target root: $ProfilePath")
  }

  $content = Get-Content -LiteralPath $ProfilePath -Raw
  $newline = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }
  $lines = [System.Collections.Generic.List[string]]::new()
  foreach ($line in ($content -split "\r?\n")) {
    $lines.Add($line)
  }

  $workflowStart = -1
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^workflow:\s*$') {
      $workflowStart = $i
      break
    }
  }
  if ($workflowStart -lt 0) {
    Fail("workflow section is missing in target profile: $ProfilePath")
  }

  $workflowEnd = $lines.Count
  for ($i = $workflowStart + 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^[A-Za-z0-9_]+:\s*$') {
      $workflowEnd = $i
      break
    }
  }

  $taskRootIndex = -1
  $runtimeRootIndex = -1
  for ($i = $workflowStart + 1; $i -lt $workflowEnd; $i++) {
    if ($lines[$i] -match '^\s{2}task_root:\s*.*$') {
      $taskRootIndex = $i
    }
    if ($lines[$i] -match '^\s{2}runtime_root:\s*.*$') {
      $runtimeRootIndex = $i
    }
  }

  if ($taskRootIndex -ge 0) {
    $lines[$taskRootIndex] = '  task_root: ".agentrail/work"'
  } else {
    $taskRootIndex = $workflowStart + 1
    $lines.Insert($taskRootIndex, '  task_root: ".agentrail/work"')
    if ($workflowEnd -gt $taskRootIndex) {
      $workflowEnd++
    }
  }

  if ($runtimeRootIndex -ge 0) {
    $lines[$runtimeRootIndex] = '  runtime_root: ".agentrail"'
  } else {
    $insertIndex = $taskRootIndex + 1
    if ($insertIndex -gt $lines.Count) {
      $insertIndex = $lines.Count
    }
    $lines.Insert($insertIndex, '  runtime_root: ".agentrail"')
  }

  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*-\s*"work"\s*$' -or $lines[$i] -match '^\s*-\s*work\s*$') {
      $indentMatch = [Regex]::Match($lines[$i], '^(\s*)-\s*.*$')
      $indent = if ($indentMatch.Success) { $indentMatch.Groups[1].Value } else { "" }
      $lines[$i] = $indent + '- ".agentrail/work"'
    }
  }

  $updatedContent = $lines -join $newline
  if ($DryRunMode.IsPresent) {
    Write-Output "PLAN PROFILE UPDATE: workflow.task_root => .agentrail/work, workflow.runtime_root => .agentrail"
    return
  }

  Set-Content -LiteralPath $ProfilePath -Value $updatedContent -Encoding utf8
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath "../..")).Path
$runtimeSourceFullPath = if ([System.IO.Path]::IsPathRooted($RuntimeSource)) {
  $RuntimeSource
} else {
  Join-Path -Path $repoRoot -ChildPath $RuntimeSource
}

if (-not (Test-Path -LiteralPath $runtimeSourceFullPath -PathType Container)) {
  Fail("Runtime source directory does not exist: $runtimeSourceFullPath")
}

$targetRootFullPath = if ([System.IO.Path]::IsPathRooted($TargetRoot)) {
  $TargetRoot
} else {
  Join-Path -Path $repoRoot -ChildPath $TargetRoot
}

if (-not $DryRun.IsPresent) {
  Ensure-Directory -Path $targetRootFullPath
}

$sourceFiles = Get-ChildItem -LiteralPath $runtimeSourceFullPath -File -Recurse | Sort-Object FullName
if ($sourceFiles.Count -eq 0) {
  Fail("Runtime source is empty: $runtimeSourceFullPath")
}

$copyPlans = New-Object System.Collections.Generic.List[object]
$createCount = 0
$overwriteCount = 0
$skipCount = 0
$conflictCount = 0

foreach ($sourceFile in $sourceFiles) {
  $relativePath = Normalize-RelativePath -Value ([System.IO.Path]::GetRelativePath($runtimeSourceFullPath, $sourceFile.FullName))
  $destinationPath = Join-Path -Path $targetRootFullPath -ChildPath $relativePath.Replace("/", [System.IO.Path]::DirectorySeparatorChar)

  if (-not (Test-Path -LiteralPath $destinationPath -PathType Leaf)) {
    $createCount++
    $copyPlans.Add([PSCustomObject]@{
        type            = "create"
        relative_path   = $relativePath
        source_full     = $sourceFile.FullName
        destination_full = $destinationPath
      }) | Out-Null
    continue
  }

  $sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
  $destinationHash = (Get-FileHash -LiteralPath $destinationPath -Algorithm SHA256).Hash
  if ($sourceHash -eq $destinationHash) {
    $skipCount++
    $copyPlans.Add([PSCustomObject]@{
        type            = "skip"
        relative_path   = $relativePath
        source_full     = $sourceFile.FullName
        destination_full = $destinationPath
      }) | Out-Null
    continue
  }

  if ($Force.IsPresent) {
    $overwriteCount++
    $copyPlans.Add([PSCustomObject]@{
        type            = "overwrite"
        relative_path   = $relativePath
        source_full     = $sourceFile.FullName
        destination_full = $destinationPath
      }) | Out-Null
    continue
  }

  $conflictCount++
  $copyPlans.Add([PSCustomObject]@{
      type            = "conflict"
      relative_path   = $relativePath
      source_full     = $sourceFile.FullName
      destination_full = $destinationPath
    }) | Out-Null
}

$agentrailWorkDir = Join-Path -Path $targetRootFullPath -ChildPath ".agentrail/work"
$gitkeepPath = Join-Path -Path $agentrailWorkDir -ChildPath ".gitkeep"
$profilePath = Join-Path -Path $targetRootFullPath -ChildPath "project.profile.yaml"

Write-Output "runtime-install: target_root=$targetRootFullPath"
Write-Output "runtime-install: runtime_source=$runtimeSourceFullPath"
Write-Output "runtime-install: dry_run=$($DryRun.IsPresent) force=$($Force.IsPresent)"
Write-Output "runtime-install: file_summary create=$createCount overwrite=$overwriteCount skip=$skipCount conflict=$conflictCount"

foreach ($plan in ($copyPlans | Where-Object { $_.type -in @("create", "overwrite", "conflict") } | Select-Object -First 30)) {
  $prefix = switch ($plan.type) {
    "create" { "+" }
    "overwrite" { "~" }
    "conflict" { "!" }
    default { " " }
  }
  Write-Output ("PLAN " + $prefix + " " + $plan.relative_path)
}
if (@($copyPlans | Where-Object { $_.type -in @("create", "overwrite", "conflict") }).Count -gt 30) {
  Write-Output "PLAN ... truncated to first 30 entries"
}

if ($conflictCount -gt 0 -and -not $Force.IsPresent) {
  Fail("Conflicting files detected. Re-run with -Force to overwrite.")
}

if ($DryRun.IsPresent) {
  Write-Output "PLAN MKDIR: .agentrail/work"
  Write-Output "PLAN TOUCH: .agentrail/work/.gitkeep"
  $profilePlanned = @($copyPlans | Where-Object { $_.relative_path -eq "project.profile.yaml" -and $_.type -in @("create", "overwrite", "skip") }).Count -gt 0
  if (Test-Path -LiteralPath $profilePath -PathType Leaf) {
    Update-TargetProfile -ProfilePath $profilePath -DryRunMode
  } elseif ($profilePlanned) {
    Write-Output "PLAN PROFILE UPDATE: workflow.task_root => .agentrail/work, workflow.runtime_root => .agentrail"
  } else {
    Fail("project.profile.yaml is not available in target and not planned from runtime source.")
  }
  Write-Output "runtime-install: PASS (dry-run)"
  exit 0
}

foreach ($plan in $copyPlans) {
  if ($plan.type -eq "skip") {
    continue
  }
  $destinationDir = Split-Path -Parent $plan.destination_full
  Ensure-Directory -Path $destinationDir
  Copy-Item -LiteralPath $plan.source_full -Destination $plan.destination_full -Force
}

Ensure-Directory -Path $agentrailWorkDir
if (-not (Test-Path -LiteralPath $gitkeepPath -PathType Leaf)) {
  Set-Content -LiteralPath $gitkeepPath -Value "" -Encoding utf8
}

Update-TargetProfile -ProfilePath $profilePath

Write-Output "runtime-install: PASS (apply)"
exit 0
