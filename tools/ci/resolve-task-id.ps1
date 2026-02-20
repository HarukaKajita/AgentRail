param(
  [Parameter(Mandatory = $true)]
  [string]$EventName,
  [string]$RepoRoot = ".",
  [string]$HeadSha = "",
  [string]$BaseSha = "",
  [string]$ManualTaskId = "",
  [string]$ProfilePath = "project.profile.yaml"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")

function Fail {
  param([string]$Message)
  Write-Error "resolve-task-id: $Message"
  exit 1
}

function Normalize-PathString {
  param([string]$Value)
  return $Value.Replace("\", "/")
}

function Ensure-TaskExists {
  param(
    [string]$Root,
    [string]$TaskRoot,
    [string]$TaskId
  )

  $taskPath = if ([System.IO.Path]::IsPathRooted($TaskRoot)) {
    Join-Path -Path $TaskRoot -ChildPath $TaskId
  } else {
    Join-Path -Path $Root -ChildPath (Join-Path -Path $TaskRoot -ChildPath $TaskId)
  }
  if (-not (Test-Path -LiteralPath $taskPath -PathType Container)) {
    Fail("Task directory does not exist: $TaskRoot/$TaskId")
  }
}

function Emit-Result {
  param(
    [string]$TaskId = "",
    [string]$Source
  )

  Write-Output "resolve-task-id: source=$Source task_id=$TaskId"
  if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_OUTPUT)) {
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "resolved_task_id=$TaskId"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "resolved_task_source=$Source"
  }
  Write-Output "resolved_task_id=$TaskId"
  exit 0
}

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
  Fail("Repo root does not exist: $RepoRoot")
}

$resolvedProfilePath = if ([System.IO.Path]::IsPathRooted($ProfilePath)) {
  $ProfilePath
} else {
  Join-Path -Path $RepoRoot -ChildPath $ProfilePath
}

$workflowPaths = Resolve-WorkflowPaths -ProfilePath $resolvedProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
$taskRoot = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.task_root
$workDir = if ([System.IO.Path]::IsPathRooted($taskRoot)) {
  $taskRoot
} else {
  Join-Path -Path $RepoRoot -ChildPath $taskRoot
}

if (-not (Test-Path -LiteralPath $workDir -PathType Container)) {
  Fail("task root directory does not exist under repo root: $taskRoot")
}

$manual = ([string]$ManualTaskId).Trim()
if (-not [string]::IsNullOrWhiteSpace($manual)) {
  Ensure-TaskExists -Root $RepoRoot -TaskRoot $taskRoot -TaskId $manual
  Emit-Result -TaskId $manual -Source "manual"
}

$changedFiles = @()
if ($EventName -eq "pull_request") {
  if ([string]::IsNullOrWhiteSpace($BaseSha) -or [string]::IsNullOrWhiteSpace($HeadSha)) {
    Fail("pull_request event requires BaseSha and HeadSha.")
  }
  $changedFiles = & git -C $RepoRoot diff --name-only "$BaseSha...$HeadSha"
  if ($LASTEXITCODE -ne 0) {
    Fail("Failed to collect changed files from pull_request diff.")
  }
}
elseif ($EventName -eq "push") {
  if ([string]::IsNullOrWhiteSpace($HeadSha)) {
    Fail("push event requires HeadSha.")
  }

  $isNullBefore = [string]::IsNullOrWhiteSpace($BaseSha) -or $BaseSha -eq "0000000000000000000000000000000000000000"
  if (-not $isNullBefore) {
    $changedFiles = & git -C $RepoRoot diff --name-only "$BaseSha...$HeadSha"
    if ($LASTEXITCODE -ne 0) {
      Fail("Failed to collect changed files from push diff.")
    }
  } else {
    Write-Output "resolve-task-id: push event without valid BaseSha, collecting files from HeadSha."
    $changedFiles = & git -C $RepoRoot diff-tree --no-commit-id --name-only -r "$HeadSha"
    if ($LASTEXITCODE -ne 0) {
      Fail("Failed to collect changed files from push head commit.")
    }
  }
}
elseif ($EventName -eq "workflow_dispatch") {
  Fail("workflow_dispatch event requires non-empty task_id input (ManualTaskId).")
}
else {
  Fail("Unsupported event name: $EventName")
}

$taskIdsFromDiff = New-Object System.Collections.Generic.HashSet[string]
$escapedTaskRoot = [Regex]::Escape($taskRoot)
foreach ($file in $changedFiles) {
  $normalized = Normalize-PathString -Value $file
  if ($normalized -match "^$escapedTaskRoot/([^/]+)/") {
    $taskIdsFromDiff.Add($Matches[1]) | Out-Null
  }
}

$resolvedDiffTasks = @()
if ($taskIdsFromDiff.Count -gt 0) {
  $resolvedDiffTasks = @($taskIdsFromDiff | Sort-Object)
}
if ($resolvedDiffTasks.Count -eq 1) {
  $taskId = [string]$resolvedDiffTasks[0]
  Ensure-TaskExists -Root $RepoRoot -TaskRoot $taskRoot -TaskId $taskId
  Emit-Result -TaskId $taskId -Source "diff"
}

if ($resolvedDiffTasks.Count -gt 1) {
  $joined = $resolvedDiffTasks -join ", "
  Fail("Multiple task IDs were found in changed files: $joined")
}

Emit-Result -TaskId "" -Source "skip"
