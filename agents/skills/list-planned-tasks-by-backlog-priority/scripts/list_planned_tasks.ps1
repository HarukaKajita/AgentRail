param(
    [string]$RepoRoot = ".",
    [string]$BacklogPath = "docs/operations/high-priority-backlog.md",
    [string]$WorkDir = "work"
)

$ErrorActionPreference = "Stop"

function Stop-WithError {
    param([string]$Message)
    Write-Error $Message
    exit 1
}

$repoRootResolved = (Resolve-Path -Path $RepoRoot).Path
$backlogFullPath = Join-Path -Path $repoRootResolved -ChildPath $BacklogPath
$workFullPath = Join-Path -Path $repoRootResolved -ChildPath $WorkDir

if (-not (Test-Path -Path $backlogFullPath -PathType Leaf)) {
    Stop-WithError "Backlog file not found: $backlogFullPath"
}

if (-not (Test-Path -Path $workFullPath -PathType Container)) {
    Stop-WithError "Work directory not found: $workFullPath"
}

$backlogLines = Get-Content -Path $backlogFullPath
$docsTaskOrder = New-Object System.Collections.Generic.List[string]
$inPrioritySection = $false

foreach ($line in $backlogLines) {
    if ($line -match '^##\s+(優先タスク一覧|Priority Tasks|Priority Task List)\s*$') {
        $inPrioritySection = $true
        continue
    }

    if ($inPrioritySection -and $line -match '^##\s+') {
        break
    }

    if (-not $inPrioritySection) {
        continue
    }

    if ($line -match '^\s*\d+\.\s+`(?<id>[^`]+)`\s*$') {
        $taskId = $Matches['id'].Trim()
        if (-not [string]::IsNullOrWhiteSpace($taskId) -and -not $docsTaskOrder.Contains($taskId)) {
            $docsTaskOrder.Add($taskId)
        }
        continue
    }

    if ($line -match '^\s*\d+\.\s+(?<id>\d{4}-\d{2}-\d{2}__[A-Za-z0-9._-]+)\s*$') {
        $taskId = $Matches['id'].Trim()
        if (-not [string]::IsNullOrWhiteSpace($taskId) -and -not $docsTaskOrder.Contains($taskId)) {
            $docsTaskOrder.Add($taskId)
        }
    }
}

if (-not $inPrioritySection) {
    Stop-WithError "Priority section not found in backlog: $backlogFullPath"
}

$stateByTask = @{}
$plannedTaskSet = New-Object System.Collections.Generic.HashSet[string]
$warnings = New-Object System.Collections.Generic.List[string]

$taskDirectories = Get-ChildItem -Path $workFullPath -Directory
foreach ($taskDir in $taskDirectories) {
    $taskId = $taskDir.Name
    $statePath = Join-Path -Path $taskDir.FullName -ChildPath 'state.json'

    if (-not (Test-Path -Path $statePath -PathType Leaf)) {
        continue
    }

    try {
        $stateJson = Get-Content -Raw -Path $statePath | ConvertFrom-Json
    }
    catch {
        $warnings.Add("Invalid JSON in $statePath")
        continue
    }

    $state = [string]$stateJson.state
    $stateByTask[$taskId] = $state

    if ($state -eq 'planned') {
        [void]$plannedTaskSet.Add($taskId)
    }
}

$resultRows = New-Object System.Collections.Generic.List[object]
$seen = New-Object System.Collections.Generic.HashSet[string]

foreach ($taskId in $docsTaskOrder) {
    if (-not $stateByTask.ContainsKey($taskId)) {
        $warnings.Add("Task listed in backlog but state.json is missing: $taskId")
        continue
    }

    $state = $stateByTask[$taskId]
    if ($state -ne 'planned') {
        $warnings.Add("Task listed in backlog but state is '$state': $taskId")
        continue
    }

    $resultRows.Add([pscustomobject]@{
        task_id = $taskId
        source  = 'docs'
    })
    [void]$seen.Add($taskId)
}

$workOnlyPlanned = @($plannedTaskSet | Where-Object { -not $seen.Contains($_) } | Sort-Object)
foreach ($taskId in $workOnlyPlanned) {
    $resultRows.Add([pscustomobject]@{
        task_id = $taskId
        source  = 'work-only'
    })
    $warnings.Add("Planned task missing from backlog priority list: $taskId")
}

Write-Output 'Planned Tasks (Priority Order)'
if ($resultRows.Count -eq 0) {
    Write-Output 'None'
}
else {
    $index = 1
    foreach ($row in $resultRows) {
        Write-Output ("{0}. {1} (source: {2})" -f $index, $row.task_id, $row.source)
        $index++
    }
}

Write-Output ''
Write-Output 'Warnings'
$uniqueWarnings = @($warnings | Sort-Object -Unique)
if ($uniqueWarnings.Count -eq 0) {
    Write-Output 'None'
}
else {
    foreach ($warning in $uniqueWarnings) {
        Write-Output ("- {0}" -f $warning)
    }
}

Write-Output ''
Write-Output 'Sources'
Write-Output ("- backlog: {0}" -f $backlogFullPath)
Write-Output ("- work: {0}" -f $workFullPath)
