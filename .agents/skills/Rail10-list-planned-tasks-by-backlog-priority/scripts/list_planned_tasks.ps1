param(
    [string]$RepoRoot = ".",
    [string]$BacklogPath = "docs/operations/high-priority-backlog.md",
    [string]$WorkDir = "work"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Stop-WithError {
    param([string]$Message)
    Write-Error $Message
    exit 1
}

function Parse-DependencyValues {
    param([string]$RawValue)

    if ([string]::IsNullOrWhiteSpace($RawValue)) {
        return @()
    }

    $normalized = $RawValue.Trim()
    if ($normalized -match '^(なし|none|n/a|-\s*)$') {
        return @()
    }

    $values = New-Object System.Collections.Generic.List[string]
    $backtickMatches = @([Regex]::Matches($normalized, '`([^`]+)`'))
    if ($backtickMatches.Count -gt 0) {
        foreach ($match in $backtickMatches) {
            $taskId = $match.Groups[1].Value.Trim()
            if ([string]::IsNullOrWhiteSpace($taskId)) {
                continue
            }
            if ($values.Contains($taskId)) {
                continue
            }
            $values.Add($taskId) | Out-Null
        }
        return $values.ToArray()
    }

    foreach ($token in ($normalized -split ",")) {
        $taskId = $token.Trim()
        if ([string]::IsNullOrWhiteSpace($taskId)) {
            continue
        }
        if ($values.Contains($taskId)) {
            continue
        }
        $values.Add($taskId) | Out-Null
    }

    return $values.ToArray()
}

function Get-DependencyCycle {
    param(
        [string]$StartTaskId,
        [hashtable]$DependencyMap
    )

    if (-not $DependencyMap.ContainsKey($StartTaskId)) {
        return ""
    }

    $stack = New-Object System.Collections.Stack
    $path = New-Object System.Collections.Generic.List[string]
    $nextIndexByTask = @{}
    $closedSet = New-Object System.Collections.Generic.HashSet[string]

    $stack.Push($StartTaskId)
    while ($stack.Count -gt 0) {
        $currentTaskId = [string]$stack.Peek()
        if (-not $nextIndexByTask.ContainsKey($currentTaskId)) {
            $nextIndexByTask[$currentTaskId] = 0
            $path.Add($currentTaskId) | Out-Null
        }

        $dependencies = @()
        if ($DependencyMap.ContainsKey($currentTaskId)) {
            $dependencies = @($DependencyMap[$currentTaskId])
        }

        $nextIndex = [int]$nextIndexByTask[$currentTaskId]
        if ($nextIndex -ge $dependencies.Count) {
            [void]$stack.Pop()
            [void]$nextIndexByTask.Remove($currentTaskId)
            [void]$closedSet.Add($currentTaskId)
            if ($path.Count -gt 0) {
                $path.RemoveAt($path.Count - 1)
            }
            continue
        }

        $dependencyId = [string]$dependencies[$nextIndex]
        $nextIndexByTask[$currentTaskId] = $nextIndex + 1

        if (-not $DependencyMap.ContainsKey($dependencyId)) {
            continue
        }

        $activeIndex = $path.IndexOf($dependencyId)
        if ($activeIndex -ge 0) {
            $cycleNodes = @($path[$activeIndex..($path.Count - 1)])
            $cycleNodes += $dependencyId
            return ($cycleNodes -join " -> ")
        }

        if ($closedSet.Contains($dependencyId)) {
            continue
        }

        $stack.Push($dependencyId)
    }

    return ""
}

function Format-DependencyList {
    param([string[]]$DependencyIds)

    if ($null -eq $DependencyIds -or $DependencyIds.Count -eq 0) {
        return "none"
    }

    return ($DependencyIds -join ", ")
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
$docsDependencies = @{}
$docsDependencyLine = @{}
$inPrioritySection = $false
$currentTaskId = ""

foreach ($line in $backlogLines) {
    if ($line -match '^##\s+(優先タスク一覧|Priority Tasks|Priority Task List)\s*$') {
        $inPrioritySection = $true
        continue
    }

    if (-not $inPrioritySection) {
        continue
    }

    if ($line -match '^##\s+') {
        break
    }

    if ($line -match '^\s*\d+\.\s+`(?<id>[^`]+)`\s*$') {
        $taskId = $Matches['id'].Trim()
        if (-not [string]::IsNullOrWhiteSpace($taskId) -and -not $docsTaskOrder.Contains($taskId)) {
            $docsTaskOrder.Add($taskId)
            $docsDependencies[$taskId] = @()
            $docsDependencyLine[$taskId] = $false
        }
        $currentTaskId = $taskId
        continue
    }

    if ($line -match '^\s*\d+\.\s+(?<id>\d{4}-\d{2}-\d{2}__[A-Za-z0-9._-]+)\s*$') {
        $taskId = $Matches['id'].Trim()
        if (-not [string]::IsNullOrWhiteSpace($taskId) -and -not $docsTaskOrder.Contains($taskId)) {
            $docsTaskOrder.Add($taskId)
            $docsDependencies[$taskId] = @()
            $docsDependencyLine[$taskId] = $false
        }
        $currentTaskId = $taskId
        continue
    }

    if ([string]::IsNullOrWhiteSpace($currentTaskId)) {
        continue
    }

    if ($line -match '^\s*-\s*(依存|Depends on)\s*:\s*(?<value>.+?)\s*$') {
        $docsDependencies[$currentTaskId] = Parse-DependencyValues -RawValue $Matches["value"]
        $docsDependencyLine[$currentTaskId] = $true
    }
}

if (-not $inPrioritySection) {
    Stop-WithError "Priority section not found in backlog: $backlogFullPath"
}

$stateByTask = @{}
$dependsOnByTask = @{}
$plannedTaskSet = New-Object System.Collections.Generic.HashSet[string]
$warnings = New-Object System.Collections.Generic.List[string]

$taskDirectories = Get-ChildItem -Path $workFullPath -Directory
foreach ($taskDir in $taskDirectories) {
    $taskId = $taskDir.Name
    $statePath = Join-Path -Path $taskDir.FullName -ChildPath "state.json"

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

    $dependencyIds = New-Object System.Collections.Generic.List[string]
    if (-not ($stateJson.PSObject.Properties.Name -contains "depends_on")) {
        $warnings.Add("state.json is missing depends_on: $taskId")
    } elseif ($null -eq $stateJson.depends_on) {
        $warnings.Add("depends_on must be an array: $taskId")
    } else {
        foreach ($rawDependencyId in @($stateJson.depends_on)) {
            $dependencyId = [string]$rawDependencyId
            if ([string]::IsNullOrWhiteSpace($dependencyId)) {
                $warnings.Add("depends_on contains empty task id: $taskId")
                continue
            }
            if ($dependencyIds.Contains($dependencyId)) {
                $warnings.Add("depends_on contains duplicate task id '$dependencyId': $taskId")
                continue
            }
            if ($dependencyId -eq $taskId) {
                $warnings.Add("depends_on contains self task id: $taskId")
            }
            $dependencyIds.Add($dependencyId) | Out-Null
        }
    }
    $dependsOnByTask[$taskId] = $dependencyIds.ToArray()

    if ($state -eq "planned") {
        [void]$plannedTaskSet.Add($taskId)
    }
}

$resultRows = New-Object System.Collections.Generic.List[object]
$seen = New-Object System.Collections.Generic.HashSet[string]
$priorityIndex = 1

foreach ($taskId in $docsTaskOrder) {
    if (-not $stateByTask.ContainsKey($taskId)) {
        $warnings.Add("Task listed in backlog but state.json is missing: $taskId")
        continue
    }

    $state = $stateByTask[$taskId]
    if ($state -ne "planned") {
        $warnings.Add("Task listed in backlog but state is '$state': $taskId")
        continue
    }

    $stateDependencies = @(if ($dependsOnByTask.ContainsKey($taskId)) { @($dependsOnByTask[$taskId]) } else { @() })
    $backlogDependencies = @(if ($docsDependencies.ContainsKey($taskId)) { @($docsDependencies[$taskId]) } else { @() })

    if (-not ($docsDependencyLine.ContainsKey($taskId) -and [bool]$docsDependencyLine[$taskId])) {
        $warnings.Add("Backlog task is missing dependency line: $taskId")
    } else {
        $stateFingerprint = (@($stateDependencies | Sort-Object) -join ",")
        $backlogFingerprint = (@($backlogDependencies | Sort-Object) -join ",")
        if ($stateFingerprint -ne $backlogFingerprint) {
            $warnings.Add("Backlog dependency mismatch with state.json: $taskId")
        }
    }

    $unresolved = New-Object System.Collections.Generic.List[string]
    foreach ($dependencyId in $stateDependencies) {
        if (-not $stateByTask.ContainsKey($dependencyId)) {
            $unresolved.Add("$dependencyId[missing]") | Out-Null
            continue
        }
        $dependencyState = [string]$stateByTask[$dependencyId]
        if ($dependencyState -ne "done") {
            $unresolved.Add("$dependencyId[$dependencyState]") | Out-Null
        }
    }

    $dependencyStatus = if ($stateDependencies.Count -eq 0) {
        "none"
    } elseif ($unresolved.Count -eq 0) {
        "resolved"
    } else {
        "blocked"
    }

    $resultRows.Add([pscustomobject]@{
        task_id            = $taskId
        source             = "docs"
        priority_index     = $priorityIndex
        depends_on         = $stateDependencies
        dependency_status  = $dependencyStatus
        unresolved         = $unresolved.ToArray()
    })
    $priorityIndex++
    [void]$seen.Add($taskId)
}

$workOnlyPlanned = @($plannedTaskSet | Where-Object { -not $seen.Contains($_) } | Sort-Object)
foreach ($taskId in $workOnlyPlanned) {
    $stateDependencies = @(if ($dependsOnByTask.ContainsKey($taskId)) { @($dependsOnByTask[$taskId]) } else { @() })
    $unresolved = New-Object System.Collections.Generic.List[string]
    foreach ($dependencyId in $stateDependencies) {
        if (-not $stateByTask.ContainsKey($dependencyId)) {
            $unresolved.Add("$dependencyId[missing]") | Out-Null
            continue
        }
        $dependencyState = [string]$stateByTask[$dependencyId]
        if ($dependencyState -ne "done") {
            $unresolved.Add("$dependencyId[$dependencyState]") | Out-Null
        }
    }

    $dependencyStatus = if ($stateDependencies.Count -eq 0) {
        "none"
    } elseif ($unresolved.Count -eq 0) {
        "resolved"
    } else {
        "blocked"
    }

    $resultRows.Add([pscustomobject]@{
        task_id            = $taskId
        source             = "work-only"
        priority_index     = 100000 + $priorityIndex
        depends_on         = $stateDependencies
        dependency_status  = $dependencyStatus
        unresolved         = $unresolved.ToArray()
    })
    $priorityIndex++
    $warnings.Add("Planned task missing from backlog priority list: $taskId")
}

$dependencyMap = @{}
foreach ($pair in $dependsOnByTask.GetEnumerator()) {
    $dependencyMap[$pair.Key] = @($pair.Value)
}

$cycleWarnings = New-Object System.Collections.Generic.HashSet[string]
foreach ($row in $resultRows) {
    $cyclePath = Get-DependencyCycle -StartTaskId $row.task_id -DependencyMap $dependencyMap
    if (-not [string]::IsNullOrWhiteSpace($cyclePath)) {
        [void]$cycleWarnings.Add("Dependency cycle detected: $cyclePath")
    }
}
foreach ($cycleWarning in $cycleWarnings) {
    $warnings.Add($cycleWarning)
}

$readyRows = @($resultRows | Where-Object { $_.dependency_status -ne "blocked" } | Sort-Object priority_index, task_id)
$blockedRows = @($resultRows | Where-Object { $_.dependency_status -eq "blocked" } | Sort-Object priority_index, task_id)
$orderedRows = @($readyRows + $blockedRows)

Write-Output "Planned Tasks (Priority Order)"
if ($orderedRows.Count -eq 0) {
    Write-Output "None"
}
else {
    $index = 1
    foreach ($row in $orderedRows) {
        $dependsLabel = Format-DependencyList -DependencyIds @($row.depends_on)
        $unresolvedLabel = Format-DependencyList -DependencyIds @($row.unresolved)
        Write-Output ("{0}. {1} (source: {2}, dependency: {3}, depends_on: {4}, unresolved: {5})" -f $index, $row.task_id, $row.source, $row.dependency_status, $dependsLabel, $unresolvedLabel)
        $index++
    }
}

Write-Output ""
Write-Output "Ready Tasks (Dependency Resolved)"
if ($readyRows.Count -eq 0) {
    Write-Output "None"
}
else {
    foreach ($row in $readyRows) {
        Write-Output ("- {0}" -f $row.task_id)
    }
}

Write-Output ""
Write-Output "Blocked Tasks (Unresolved Dependencies)"
if ($blockedRows.Count -eq 0) {
    Write-Output "None"
}
else {
    foreach ($row in $blockedRows) {
        Write-Output ("- {0}: {1}" -f $row.task_id, (Format-DependencyList -DependencyIds @($row.unresolved)))
    }
}

Write-Output ""
Write-Output "Warnings"
$uniqueWarnings = @($warnings | Sort-Object -Unique)
if ($uniqueWarnings.Count -eq 0) {
    Write-Output "None"
}
else {
    foreach ($warning in $uniqueWarnings) {
        Write-Output ("- {0}" -f $warning)
    }
}

Write-Output ""
Write-Output "Sources"
Write-Output ("- backlog: {0}" -f $backlogFullPath)
Write-Output ("- work: {0}" -f $workFullPath)

Write-Output ""
Write-Output "Proposal Options"
if ($orderedRows.Count -eq 0) {
    Write-Output "- Option A: まず `work/*/state.json` の planned 候補と depends_on を補完する。"
    Write-Output "- Option B: `docs/operations/high-priority-backlog.md` を再構築し、優先順と依存を再定義する。"
    Write-Output "- Option C: validator/checker を実行して整合エラーを先に解消する。"
}
elseif ($readyRows.Count -gt 0) {
    $topReadyTask = $readyRows[0].task_id
    Write-Output ("- Option A: 最優先 ready task `'{0}'` を単独で着手し、完了後に次タスクへ進む。" -f $topReadyTask)

    if ($readyRows.Count -ge 2) {
        $secondReadyTask = $readyRows[1].task_id
        Write-Output ("- Option B: ready task `'{0}'` と `'{1}'` を順に処理する。" -f $topReadyTask, $secondReadyTask)
    }
    elseif ($blockedRows.Count -gt 0) {
        $firstBlockedTask = $blockedRows[0].task_id
        Write-Output ("- Option B: `'{0}'` 完了後に blocked task `'{1}'` の依存解決を確認する。" -f $topReadyTask, $firstBlockedTask)
    }
    else {
        Write-Output ("- Option B: `'{0}'` の着手前にテスト要件と docs 更新範囲を再確認する。" -f $topReadyTask)
    }

    if ($uniqueWarnings.Count -gt 0) {
        Write-Output "- Option C: warnings の解消を先行し、backlog/state の依存整合を回復してから実装へ進む。"
    }
    else {
        Write-Output "- Option C: 現在の依存解決済み優先順を維持し、1タスクごとに review 完了まで進める。"
    }
}
else {
    $topBlockedTask = $blockedRows[0].task_id
    Write-Output ("- Option A: blocked task `'{0}'` の依存先を先行タスクとして着手する。" -f $topBlockedTask)
    Write-Output "- Option B: 依存先 task の state 更新を完了させ、再度 Rail10 出力で ready 判定を確認する。"
    Write-Output "- Option C: 依存循環/不存在の warnings を解消してから優先度順に復帰する。"
}

Write-Output ""
Write-Output "Clarifying Questions"
if ($orderedRows.Count -eq 0) {
    Write-Output "- Q1. planned として扱うべき task-id を新規に起票しますか？"
    Write-Output "- Q2. backlog の優先順と depends_on をどちらの資料で正としますか？"
}
elseif ($readyRows.Count -gt 0) {
    $topReadyTask = $readyRows[0].task_id
    Write-Output ("- Q1. 最優先 ready task `'{0}'` を次の実装対象として確定しますか？" -f $topReadyTask)
    Write-Output "- Q2. 同時並行で進めるタスク数は 1 件に固定しますか？"
    if ($uniqueWarnings.Count -gt 0) {
        Write-Output "- Q3. warnings の依存不整合を先に是正してから実装へ進みますか？"
    }
    else {
        Write-Output "- Q3. 次順位タスクまで依存解決済み優先順を固定してよいですか？"
    }
}
else {
    $topBlockedTask = $blockedRows[0].task_id
    Write-Output ("- Q1. blocked task `'{0}'` の依存先を先に完了させる方針で確定しますか？" -f $topBlockedTask)
    Write-Output "- Q2. 依存循環または不存在依存がある場合、追加起票と修正のどちらを優先しますか？"
    Write-Output "- Q3. ready task が出るまで着手を保留しますか？"
}
