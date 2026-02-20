param(
  [Parameter(Mandatory = $true)]
  [string]$TaskId,
  [ValidateSet("kickoff", "implementation", "finalize")]
  [string]$Phase = "implementation",
  [string[]]$StagedFiles = @(),
  [string[]]$AdditionalAllowedPaths = @(),
  [switch]$AllowCommonSharedPaths,
  [string]$ProfilePath = "project.profile.yaml"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")

function Normalize-RepoPath {
  param([string]$PathValue)
  if ([string]::IsNullOrWhiteSpace($PathValue)) {
    return ""
  }
  return $PathValue.Replace("\", "/").Trim()
}

function Is-UnderTaskDirectory {
  param(
    [string]$PathValue,
    [string]$ExpectedTaskId,
    [string]$TaskRoot
  )

  $prefix = "$TaskRoot/$ExpectedTaskId/"
  return $PathValue.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
}

function Get-TaskIdFromPath {
  param(
    [string]$PathValue,
    [string]$TaskRoot
  )

  $escapedTaskRoot = [Regex]::Escape($TaskRoot)
  if ($PathValue -notmatch ('^' + $escapedTaskRoot + '/([^/]+)/')) {
    return ""
  }
  return $Matches[1]
}

if ([string]::IsNullOrWhiteSpace($TaskId)) {
  Write-Output "BOUNDARY_CHECK: FAIL"
  Write-Output "reason=TaskId is required."
  exit 1
}

$normalizedTaskId = $TaskId.Trim()
$workflowPaths = Resolve-WorkflowPaths -ProfilePath $ProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
$taskRoot = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.task_root
$docsRoot = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.docs_root
$docsIndexPath = Join-NormalizedRepoPath -BasePath $docsRoot -ChildPath "INDEX.md"
$backlogPath = Join-NormalizedRepoPath -BasePath $docsRoot -ChildPath "operations/high-priority-backlog.md"

$baseAllowed = @(
  $backlogPath,
  "MEMORY.md",
  $docsIndexPath
)

if ($Phase -eq "kickoff") {
  $baseAllowed += @(
    $backlogPath,
    "MEMORY.md"
  )
}

if ($Phase -eq "finalize") {
  $baseAllowed += @(
    $docsIndexPath
  )
}

$effectiveAllowed = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

if ($AllowCommonSharedPaths) {
  foreach ($item in $baseAllowed) {
    $rawText = [string]$item
    if ([string]::IsNullOrWhiteSpace($rawText)) {
      continue
    }
    $normalized = Normalize-RepoPath -PathValue ($rawText.Trim().Trim('"'))
    if (-not [string]::IsNullOrWhiteSpace($normalized)) {
      [void]$effectiveAllowed.Add($normalized)
    }
  }
}

foreach ($item in $AdditionalAllowedPaths) {
  $rawText = [string]$item
  if ([string]::IsNullOrWhiteSpace($rawText)) {
    continue
  }

  $splitItems = $rawText -split ","
  foreach ($splitItem in $splitItems) {
    $normalized = Normalize-RepoPath -PathValue ($splitItem.Trim().Trim('"'))
    if (-not [string]::IsNullOrWhiteSpace($normalized)) {
      [void]$effectiveAllowed.Add($normalized)
    }
  }
}

$candidateFiles = @()
if ($StagedFiles.Count -gt 0) {
  $candidateFiles = $StagedFiles
} else {
  $raw = git diff --cached --name-only
  $candidateFiles = @($raw)
}

$expandedCandidates = New-Object System.Collections.Generic.List[string]
foreach ($candidate in $candidateFiles) {
  $asText = [string]$candidate
  if ([string]::IsNullOrWhiteSpace($asText)) {
    continue
  }

  $splitValues = $asText -split ","
  foreach ($splitValue in $splitValues) {
    $trimmed = $splitValue.Trim().Trim('"')
    if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
      $expandedCandidates.Add($trimmed) | Out-Null
    }
  }
}

$normalizedFiles = @()
foreach ($file in $expandedCandidates) {
  $normalized = Normalize-RepoPath -PathValue $file
  if (-not [string]::IsNullOrWhiteSpace($normalized)) {
    $normalizedFiles += $normalized
  }
}

if ($normalizedFiles.Count -eq 0) {
  Write-Output "BOUNDARY_CHECK: FAIL"
  Write-Output "reason=No staged files found."
  exit 1
}

$crossTaskFiles = New-Object System.Collections.Generic.List[string]
$foreignTaskIds = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
$nonTaskFiles = New-Object System.Collections.Generic.List[string]

foreach ($path in $normalizedFiles) {
  if (Is-UnderTaskDirectory -PathValue $path -ExpectedTaskId $normalizedTaskId -TaskRoot $taskRoot) {
    continue
  }

  $taskFromPath = Get-TaskIdFromPath -PathValue $path -TaskRoot $taskRoot
  if (-not [string]::IsNullOrWhiteSpace($taskFromPath)) {
    $crossTaskFiles.Add($path) | Out-Null
    [void]$foreignTaskIds.Add($taskFromPath)
    continue
  }

  if ($effectiveAllowed.Contains($path)) {
    continue
  }

  $nonTaskFiles.Add($path) | Out-Null
}

if ($crossTaskFiles.Count -gt 0) {
  Write-Output "BOUNDARY_CHECK: FAIL"
  Write-Output ("reason=Staged files include other task directories. target_task={0}; foreign_tasks={1}" -f $normalizedTaskId, (@($foreignTaskIds) -join ","))
  foreach ($item in $crossTaskFiles) {
    Write-Output ("cross_task_file={0}" -f $item)
  }
  exit 1
}

if ($nonTaskFiles.Count -gt 0) {
  Write-Output "BOUNDARY_CHECK: FAIL"
  Write-Output ("reason=Staged files include shared/non-task paths without explicit allowlist. target_task={0}; phase={1}" -f $normalizedTaskId, $Phase)
  foreach ($item in $nonTaskFiles) {
    Write-Output ("non_task_file={0}" -f $item)
  }
  exit 1
}

Write-Output "BOUNDARY_CHECK: PASS"
Write-Output ("task_id={0}" -f $normalizedTaskId)
Write-Output ("phase={0}" -f $Phase)
Write-Output ("staged_file_count={0}" -f $normalizedFiles.Count)
foreach ($path in $normalizedFiles) {
  Write-Output ("staged_file={0}" -f $path)
}

exit 0
