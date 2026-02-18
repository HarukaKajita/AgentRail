param(
  [Parameter(Mandatory = $true)]
  [string]$EventName,
  [string]$RepoRoot = ".",
  [string]$HeadSha = "",
  [string]$BaseSha = "",
  [string]$ManualTaskId = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

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
    [string]$TaskId
  )

  $taskPath = Join-Path -Path $Root -ChildPath (Join-Path -Path "work" -ChildPath $TaskId)
  if (-not (Test-Path -LiteralPath $taskPath -PathType Container)) {
    Fail("Task directory does not exist: work/$TaskId")
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

$workDir = Join-Path -Path $RepoRoot -ChildPath "work"
if (-not (Test-Path -LiteralPath $workDir -PathType Container)) {
  Fail("work directory does not exist under repo root.")
}

$manual = ([string]$ManualTaskId).Trim()
if (-not [string]::IsNullOrWhiteSpace($manual)) {
  Ensure-TaskExists -Root $RepoRoot -TaskId $manual
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
  Fail("workflow_dispatch event requires ManualTaskId.")
}
else {
  Fail("Unsupported event name: $EventName")
}

$taskIdsFromDiff = New-Object System.Collections.Generic.HashSet[string]
foreach ($file in $changedFiles) {
  $normalized = Normalize-PathString -Value $file
  if ($normalized -match "^work/([^/]+)/") {
    $taskIdsFromDiff.Add($Matches[1]) | Out-Null
  }
}

$resolvedDiffTasks = @()
if ($taskIdsFromDiff.Count -gt 0) {
  $resolvedDiffTasks = @($taskIdsFromDiff | Sort-Object)
}
if ($resolvedDiffTasks.Count -eq 1) {
  $taskId = [string]$resolvedDiffTasks[0]
  Ensure-TaskExists -Root $RepoRoot -TaskId $taskId
  Emit-Result -TaskId $taskId -Source "diff"
}

if ($resolvedDiffTasks.Count -gt 1) {
  $joined = $resolvedDiffTasks -join ", "
  Fail("Multiple task IDs were found in changed files: $joined")
}

Emit-Result -TaskId "" -Source "skip"
