param(
  [Parameter(Mandatory = $true, ParameterSetName = "single")]
  [string]$TaskId,
  [Parameter(Mandatory = $true, ParameterSetName = "all")]
  [switch]$AllTasks,
  [string]$WorkRoot = "work",
  [string]$DocsIndexPath = "docs/INDEX.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[object]
$successTasks = New-Object System.Collections.Generic.List[string]
$allowedStates = @("planned", "in_progress", "blocked", "done")
$requiredStateKeys = @("state", "owner", "updated_at", "blocking_issues", "depends_on")
$requiredTaskFiles = @("request.md", "investigation.md", "spec.md", "plan.md", "review.md", "state.json")
$forbiddenStateKeys = @("history", "state_history")
$script:docsIndexContent = $null
$script:normalizedDocsIndexPath = ""

function Add-Failure {
  param(
    [string]$Task,
    [string]$File,
    [string]$Reason
  )

  $failures.Add([PSCustomObject]@{
      task_id = $Task
      file    = $File
      reason  = $Reason
    })
}

function Normalize-PathString {
  param(
    [string]$Value
  )

  return $Value.Replace("\", "/")
}

function Get-HeadingBlock {
  param(
    [string]$Content,
    [string]$HeadingRegex,
    [string]$EndRegex
  )

  $startMatch = [Regex]::Match($Content, $HeadingRegex, [System.Text.RegularExpressions.RegexOptions]::Multiline)
  if (-not $startMatch.Success) {
    return $null
  }

  $startIndex = $startMatch.Index
  $searchStart = $startMatch.Index + $startMatch.Length
  $remaining = $Content.Substring($searchStart)
  $endMatch = [Regex]::Match($remaining, $EndRegex, [System.Text.RegularExpressions.RegexOptions]::Multiline)

  if ($endMatch.Success) {
    $length = $startMatch.Length + $endMatch.Index
    return $Content.Substring($startIndex, $length)
  }

  return $Content.Substring($startIndex)
}

function Get-DependsOnList {
  param(
    [string]$TaskId,
    [string]$StatePath,
    [object]$StateObject
  )

  if (-not ($StateObject.PSObject.Properties.Name -contains "depends_on")) {
    return @()
  }

  if ($null -eq $StateObject.depends_on) {
    Add-Failure -Task $TaskId -File $StatePath -Reason "depends_on must be an array."
    return @()
  }

  $dependencyIds = New-Object System.Collections.Generic.List[string]
  foreach ($rawDependencyId in @($StateObject.depends_on)) {
    $dependencyId = [string]$rawDependencyId
    if ([string]::IsNullOrWhiteSpace($dependencyId)) {
      Add-Failure -Task $TaskId -File $StatePath -Reason "depends_on must not include empty task ids."
      continue
    }

    if ($dependencyIds.Contains($dependencyId)) {
      Add-Failure -Task $TaskId -File $StatePath -Reason "depends_on must not include duplicate task ids: $dependencyId"
      continue
    }

    if ($dependencyId -eq $TaskId) {
      Add-Failure -Task $TaskId -File $StatePath -Reason "depends_on must not include self task id: $dependencyId"
      continue
    }

    $dependencyTaskDir = Join-Path -Path $WorkRoot -ChildPath $dependencyId
    if (-not (Test-Path -LiteralPath $dependencyTaskDir -PathType Container)) {
      Add-Failure -Task $TaskId -File $StatePath -Reason "depends_on references unknown task id: $dependencyId"
      continue
    }

    $dependencyIds.Add($dependencyId) | Out-Null
  }

  return $dependencyIds.ToArray()
}

function Get-DependencyCycleForTask {
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

function Validate-DependencyCycles {
  param(
    [string[]]$TargetTaskIds
  )

  $dependencyMap = @{}

  if (-not (Test-Path -LiteralPath $WorkRoot -PathType Container)) {
    return
  }

  $taskDirectories = Get-ChildItem -LiteralPath $WorkRoot -Directory
  foreach ($taskDirectory in $taskDirectories) {
    $statePath = Join-Path -Path $taskDirectory.FullName -ChildPath "state.json"
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
      continue
    }

    try {
      $stateObject = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    } catch {
      continue
    }

    if (-not ($stateObject.PSObject.Properties.Name -contains "depends_on")) {
      $dependencyMap[$taskDirectory.Name] = @()
      continue
    }

    $dependencyIds = New-Object System.Collections.Generic.List[string]
    foreach ($rawDependencyId in @($stateObject.depends_on)) {
      $dependencyId = [string]$rawDependencyId
      if ([string]::IsNullOrWhiteSpace($dependencyId)) {
        continue
      }
      if ($dependencyIds.Contains($dependencyId)) {
        continue
      }
      $dependencyIds.Add($dependencyId) | Out-Null
    }

    $dependencyMap[$taskDirectory.Name] = $dependencyIds.ToArray()
  }

  foreach ($targetTaskId in $TargetTaskIds) {
    if (-not $dependencyMap.ContainsKey($targetTaskId)) {
      continue
    }

    $cyclePath = Get-DependencyCycleForTask -StartTaskId $targetTaskId -DependencyMap $dependencyMap
    if (-not [string]::IsNullOrWhiteSpace($cyclePath)) {
      $statePath = Join-Path -Path (Join-Path -Path $WorkRoot -ChildPath $targetTaskId) -ChildPath "state.json"
      Add-Failure -Task $targetTaskId -File $statePath -Reason "Dependency cycle detected: $cyclePath"
    }
  }
}

function Validate-Task {
  param(
    [string]$TargetTaskId
  )

  $taskDir = Join-Path -Path $WorkRoot -ChildPath $TargetTaskId
  if (-not (Test-Path -LiteralPath $taskDir -PathType Container)) {
    Add-Failure -Task $TargetTaskId -File $taskDir -Reason "Task directory does not exist."
    return
  }

  foreach ($requiredFile in $requiredTaskFiles) {
    $requiredPath = Join-Path -Path $taskDir -ChildPath $requiredFile
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
      Add-Failure -Task $TargetTaskId -File $requiredPath -Reason "Required task file is missing."
    }
  }

  $statePath = Join-Path -Path $taskDir -ChildPath "state.json"
  if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    return
  }

  try {
    $stateObject = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
  } catch {
    Add-Failure -Task $TargetTaskId -File $statePath -Reason "state.json is not valid JSON."
    return
  }

  foreach ($requiredKey in $requiredStateKeys) {
    if (-not ($stateObject.PSObject.Properties.Name -contains $requiredKey)) {
      Add-Failure -Task $TargetTaskId -File $statePath -Reason "Missing required key: $requiredKey"
    }
  }

  $statePropertyNames = @($stateObject.PSObject.Properties.Name | ForEach-Object { [string]$_ })
  foreach ($propertyName in $statePropertyNames) {
    if ($propertyName.ToLowerInvariant() -in $forbiddenStateKeys) {
      Add-Failure -Task $TargetTaskId -File $statePath -Reason "state history must be externalized; forbidden key in state.json: $propertyName"
    }
  }

  if (-not ($stateObject.PSObject.Properties.Name -contains "state")) {
    return
  }

  $state = [string]$stateObject.state
  if ($state -notin $allowedStates) {
    Add-Failure -Task $TargetTaskId -File $statePath -Reason "Invalid state '$state'. Allowed: $($allowedStates -join ', ')"
    return
  }

  if ($stateObject.PSObject.Properties.Name -contains "updated_at") {
    $parsedDate = [DateTimeOffset]::MinValue
    if (-not [DateTimeOffset]::TryParse([string]$stateObject.updated_at, [ref]$parsedDate)) {
      Add-Failure -Task $TargetTaskId -File $statePath -Reason "updated_at is not a valid datetime: $($stateObject.updated_at)"
    }
  }

  $blockingIssues = @()
  if ($stateObject.PSObject.Properties.Name -contains "blocking_issues") {
    if ($null -ne $stateObject.blocking_issues) {
      $blockingIssues = @($stateObject.blocking_issues)
    }
  }

  if ($state -eq "blocked" -and $blockingIssues.Count -eq 0) {
    Add-Failure -Task $TargetTaskId -File $statePath -Reason "state=blocked requires at least one blocking issue."
  }

  if ($state -ne "blocked" -and $blockingIssues.Count -gt 0) {
    Add-Failure -Task $TargetTaskId -File $statePath -Reason "blocking_issues must be empty unless state=blocked."
  }

  $dependencyIds = Get-DependsOnList -TaskId $TargetTaskId -StatePath $statePath -StateObject $stateObject
  if ($state -in @("in_progress", "done")) {
    foreach ($dependencyId in $dependencyIds) {
      $dependencyStatePath = Join-Path -Path (Join-Path -Path $WorkRoot -ChildPath $dependencyId) -ChildPath "state.json"
      if (-not (Test-Path -LiteralPath $dependencyStatePath -PathType Leaf)) {
        Add-Failure -Task $TargetTaskId -File $statePath -Reason "state=$state requires dependency state file: $dependencyId/state.json"
        continue
      }

      try {
        $dependencyStateObject = Get-Content -LiteralPath $dependencyStatePath -Raw | ConvertFrom-Json
      } catch {
        Add-Failure -Task $TargetTaskId -File $statePath -Reason "state=$state requires valid dependency state.json: $dependencyId"
        continue
      }

      $dependencyState = [string]$dependencyStateObject.state
      if ($dependencyState -ne "done") {
        Add-Failure -Task $TargetTaskId -File $statePath -Reason "state=$state requires dependency state=done: $dependencyId (actual: $dependencyState)"
      }
    }
  }

  if ($state -eq "done") {
    $owner = [string]$stateObject.owner
    if ([string]::IsNullOrWhiteSpace($owner) -or $owner -eq "unassigned") {
      Add-Failure -Task $TargetTaskId -File $statePath -Reason "state=done requires a concrete owner."
    }

    $reviewPath = Join-Path -Path $taskDir -ChildPath "review.md"
    if (-not (Test-Path -LiteralPath $reviewPath -PathType Leaf)) {
      Add-Failure -Task $TargetTaskId -File $reviewPath -Reason "state=done requires review.md."
    } else {
      $reviewContent = Get-Content -LiteralPath $reviewPath -Raw
      $hasPendingStatus = $false
      $pendingPatterns = @(
        "(?m)^\s*-\s*AC-\d+:\s*PENDING\b",
        "(?m)^\s*-\s*実施内容:\s*PENDING\b",
        "(?m)^\s*-\s*結果:\s*PENDING\b",
        "(?m)^\s*-\s*[^:\r\n]+:\s*PENDING\b"
      )
      foreach ($pattern in $pendingPatterns) {
        if ($reviewContent -match $pattern) {
          $hasPendingStatus = $true
          break
        }
      }

      if ($hasPendingStatus) {
        Add-Failure -Task $TargetTaskId -File $reviewPath -Reason "state=done is inconsistent because review.md still has pending status lines."
      }
    }

    $specPath = Join-Path -Path $taskDir -ChildPath "spec.md"
    if (-not (Test-Path -LiteralPath $specPath -PathType Leaf)) {
      Add-Failure -Task $TargetTaskId -File $specPath -Reason "state=done requires spec.md."
    } elseif ($null -eq $script:docsIndexContent) {
      Add-Failure -Task $TargetTaskId -File $DocsIndexPath -Reason "state=done requires docs index content."
    } else {
      $specContent = Get-Content -LiteralPath $specPath -Raw
      $relatedLinksBlock = Get-HeadingBlock -Content $specContent -HeadingRegex "(?m)^##\s+9\.\s+関連資料リンク" -EndRegex "(?m)^##\s+"
      if (-not $relatedLinksBlock) {
        Add-Failure -Task $TargetTaskId -File $specPath -Reason "state=done requires '## 9. 関連資料リンク' in spec.md."
      } else {
        $docPathMatches = @([Regex]::Matches($relatedLinksBlock, '(?m)^\s*-\s+`(docs/[^`]+)`'))
        if ($docPathMatches.Count -eq 0) {
          Add-Failure -Task $TargetTaskId -File $specPath -Reason "state=done requires at least one docs path under related links."
        } else {
          foreach ($match in $docPathMatches) {
            $docPath = $match.Groups[1].Value.Trim()
            if (-not (Test-Path -LiteralPath $docPath)) {
              Add-Failure -Task $TargetTaskId -File $specPath -Reason "state=done references missing docs path: $docPath"
            }

            $normalizedDocPath = Normalize-PathString -Value $docPath
            if ($normalizedDocPath -eq $script:normalizedDocsIndexPath) {
              continue
            }

            if (-not $script:docsIndexContent.Contains($docPath)) {
              Add-Failure -Task $TargetTaskId -File $DocsIndexPath -Reason "state=done requires docs/INDEX.md to include docs path: $docPath"
            }
          }
        }
      }
    }
  }

  $taskFailures = @($failures | Where-Object { $_.task_id -eq $TargetTaskId })
  if ($taskFailures.Count -eq 0) {
    $successTasks.Add($TargetTaskId)
  }
}

if (-not (Test-Path -LiteralPath $WorkRoot -PathType Container)) {
  Add-Failure -Task "<global>" -File $WorkRoot -Reason "work root does not exist."
}

if (-not (Test-Path -LiteralPath $DocsIndexPath -PathType Leaf)) {
  Add-Failure -Task "<global>" -File $DocsIndexPath -Reason "docs index does not exist."
} else {
  $script:docsIndexContent = Get-Content -LiteralPath $DocsIndexPath -Raw
  $script:normalizedDocsIndexPath = Normalize-PathString -Value $DocsIndexPath
}

if (Test-Path -LiteralPath $WorkRoot -PathType Container) {
  $validatedTaskIds = @()
  if ($AllTasks) {
    $taskDirectories = Get-ChildItem -LiteralPath $WorkRoot -Directory | Sort-Object Name
    foreach ($taskDirectory in $taskDirectories) {
      Validate-Task -TargetTaskId $taskDirectory.Name
      $validatedTaskIds += $taskDirectory.Name
    }
  } else {
    Validate-Task -TargetTaskId $TaskId
    $validatedTaskIds += $TaskId
  }
  Validate-DependencyCycles -TargetTaskIds $validatedTaskIds
}

if ($failures.Count -eq 0) {
  Write-Output "STATE_VALIDATE: PASS"
  Write-Output "Validated tasks: $($successTasks.Count)"
  foreach ($task in $successTasks) {
    Write-Output "  + $task"
  }
  exit 0
}

Write-Output "STATE_VALIDATE: FAIL"
Write-Output "Failure Count: $($failures.Count)"
foreach ($failure in $failures) {
  Write-Output "- task_id=$($failure.task_id); file=$($failure.file); reason=$($failure.reason)"
}
exit 1
