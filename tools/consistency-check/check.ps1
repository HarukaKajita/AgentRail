param(
  [Parameter(Mandatory = $true, ParameterSetName = "single")]
  [string]$TaskId,
  [Parameter(Mandatory = $true, ParameterSetName = "multi")]
  [string[]]$TaskIds,
  [Parameter(Mandatory = $true, ParameterSetName = "all")]
  [switch]$AllTasks,
  [string]$WorkRoot = "work",
  [string]$DocsIndexPath = "docs/INDEX.md",
  [string]$ProfilePath = "project.profile.yaml",
  [ValidateSet("text", "json")]
  [string]$OutputFormat = "text",
  [string]$OutputFile = "",
  [ValidateSet("off", "warning", "fail")]
  [string]$DocQualityMode = "warning"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")
$jsonSchemaVersion = "1.0.0"
$allTasksExclusionPattern = "^(archive|legacy)(-|$)"
$prerequisiteRequiredStates = @("planned", "in_progress", "blocked")
$prerequisiteRequiredTaskFiles = @("request.md", "investigation.md", "spec.md", "plan.md", "review.md")
$docQualityRuleIds = @("DQ-001", "DQ-002", "DQ-003", "DQ-004")

$failures = New-Object System.Collections.Generic.List[object]
$script:taskStateSnapshot = $null
$script:backlogDependencyMetadata = $null
$script:taskRootLabel = ""
$script:docsRootLabel = ""
$script:backlogPath = ""

$workflowPaths = Resolve-WorkflowPaths -ProfilePath $ProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
if (-not $PSBoundParameters.ContainsKey("WorkRoot")) {
  $WorkRoot = $workflowPaths.task_root
}
if (-not $PSBoundParameters.ContainsKey("DocsIndexPath")) {
  $DocsIndexPath = $workflowPaths.docs_index_path
}

$WorkRoot = ConvertTo-NormalizedRepoPath -PathValue $WorkRoot
$DocsIndexPath = ConvertTo-NormalizedRepoPath -PathValue $DocsIndexPath
$script:taskRootLabel = $WorkRoot
$script:docsRootLabel = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.docs_root
if ([string]::IsNullOrWhiteSpace($script:docsRootLabel)) {
  $script:docsRootLabel = "docs"
}
$script:backlogPath = Join-NormalizedRepoPath -BasePath $script:docsRootLabel -ChildPath "operations/high-priority-backlog.md"

function Add-Failure {
  param(
    [string]$RuleId,
    [string]$File,
    [string]$Reason
  )

  $failures.Add([PSCustomObject]@{
      rule_id = $RuleId
      file    = $File
      reason  = $Reason
    })
}

function Get-FileOrNull {
  param(
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return $null
  }

  return Get-Content -LiteralPath $Path -Raw
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

function Normalize-MarkdownValue {
  param(
    [string]$Value
  )

  if ($null -eq $Value) {
    return ""
  }

  $trimmed = $Value.Trim()
  $backtick = [string][char]96
  if ($trimmed.Length -ge 2 -and $trimmed.StartsWith($backtick) -and $trimmed.EndsWith($backtick)) {
    return $trimmed.Substring(1, $trimmed.Length - 2).Trim()
  }

  return $trimmed
}

function Is-PathLikeToken {
  param([string]$RawToken)

  if ([string]::IsNullOrWhiteSpace($RawToken)) {
    return $false
  }

  if ($RawToken -match "^(https?://|<task-id>|Task ID|AC-\d+)") {
    return $false
  }

  if ($RawToken.Contains("<task-id>")) {
    return $false
  }

  if ($RawToken.Contains(" ")) {
    return $false
  }

  if ($RawToken.Contains("*")) {
    return $false
  }

  if ($RawToken -match "^(pwsh|powershell)$") {
    return $false
  }

  return $RawToken.Contains("/") -or
    $RawToken.EndsWith(".md") -or
    $RawToken.EndsWith(".yaml") -or
    $RawToken.EndsWith(".json") -or
    $RawToken.EndsWith(".ps1")
}

function Test-LocalPathReference {
  param(
    [string]$RawToken,
    [string]$BaseDir
  )

  $normalized = Normalize-PathString -Value $RawToken
  $candidates = New-Object System.Collections.Generic.List[string]
  $candidates.Add($normalized)
  if (-not [System.IO.Path]::IsPathRooted($normalized)) {
    $candidates.Add((Normalize-PathString -Value (Join-Path -Path $BaseDir -ChildPath $normalized)))
  }

  foreach ($candidate in $candidates) {
    if (Test-Path -LiteralPath $candidate) {
      return $true
    }
  }

  return $false
}

function Validate-PrerequisitesSection {
  param(
    [string]$Content,
    [string]$FilePath
  )

  $sectionBlock = Get-HeadingBlock -Content $Content -HeadingRegex "(?m)^##\s+前提知識(?:\s*\(Prerequisites.*?\))?(?:\s*\[空欄禁止\])?\s*$" -EndRegex "(?m)^##\s+"
  if (-not $sectionBlock) {
    Add-Failure -RuleId "prerequisites_section_present" -File $FilePath -Reason "Missing '## 前提知識' section."
    return
  }

  $tokenMatches = [Regex]::Matches($sectionBlock, '`([^`]+)`')
  $pathLikeTokens = New-Object System.Collections.Generic.List[string]
  foreach ($tokenMatch in $tokenMatches) {
    $rawToken = $tokenMatch.Groups[1].Value.Trim()
    if (-not (Is-PathLikeToken -RawToken $rawToken)) {
      continue
    }
    $pathLikeTokens.Add($rawToken) | Out-Null
  }

  if ($pathLikeTokens.Count -eq 0) {
    Add-Failure -RuleId "prerequisites_section_present" -File $FilePath -Reason "Prerequisites section must include at least one local reference path."
    return
  }

  $baseDir = Split-Path -Parent $FilePath
  foreach ($pathLikeToken in $pathLikeTokens) {
    if (-not (Test-LocalPathReference -RawToken $pathLikeToken -BaseDir $baseDir)) {
      Add-Failure -RuleId "prerequisites_section_present" -File $FilePath -Reason "Prerequisites section contains unresolved path: $pathLikeToken"
    }
  }
}

function Should-ExcludeAllTasksTarget {
  param(
    [string]$TaskDirectoryName
  )

  if ([string]::IsNullOrWhiteSpace($TaskDirectoryName)) {
    return $false
  }

  return $TaskDirectoryName.ToLowerInvariant() -match $allTasksExclusionPattern
}

function Parse-DependencyValues {
  param(
    [string]$RawValue
  )

  if ([string]::IsNullOrWhiteSpace($RawValue)) {
    return @()
  }

  $normalized = $RawValue.Trim()
  if ($normalized -match '^(なし|none|n/a|-\s*)$') {
    return @()
  }

  $backtickMatches = @([Regex]::Matches($normalized, '`([^`]+)`'))
  $result = New-Object System.Collections.Generic.List[string]
  if ($backtickMatches.Count -gt 0) {
    foreach ($match in $backtickMatches) {
      $taskId = $match.Groups[1].Value.Trim()
      if ([string]::IsNullOrWhiteSpace($taskId)) {
        continue
      }
      if ($result.Contains($taskId)) {
        continue
      }
      $result.Add($taskId) | Out-Null
    }
    return $result.ToArray()
  }

  foreach ($token in ($normalized -split ",")) {
    $taskId = $token.Trim()
    if ([string]::IsNullOrWhiteSpace($taskId)) {
      continue
    }
    if ($result.Contains($taskId)) {
      continue
    }
    $result.Add($taskId) | Out-Null
  }

  return $result.ToArray()
}

function Get-TaskStateSnapshot {
  if ($null -ne $script:taskStateSnapshot) {
    return $script:taskStateSnapshot
  }

  $snapshot = @{}
  if (-not (Test-Path -LiteralPath $WorkRoot -PathType Container)) {
    $script:taskStateSnapshot = $snapshot
    return $snapshot
  }

  $taskDirectories = Get-ChildItem -LiteralPath $WorkRoot -Directory
  foreach ($taskDirectory in $taskDirectories) {
    $taskId = $taskDirectory.Name
    $statePath = Join-Path -Path $taskDirectory.FullName -ChildPath "state.json"
    $taskInfo = [PSCustomObject]@{
      task_id      = $taskId
      state_path   = $statePath
      exists       = Test-Path -LiteralPath $statePath -PathType Leaf
      json_valid   = $false
      state        = ""
      depends_on   = @()
      has_depends  = $false
    }

    if ($taskInfo.exists) {
      try {
        $stateObject = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
        $taskInfo.json_valid = $true
        if ($stateObject.PSObject.Properties.Name -contains "state") {
          $taskInfo.state = [string]$stateObject.state
        }
        if ($stateObject.PSObject.Properties.Name -contains "depends_on") {
          $taskInfo.has_depends = $true
          if ($null -ne $stateObject.depends_on) {
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
            $taskInfo.depends_on = $dependencyIds.ToArray()
          }
        }
      } catch {
        $taskInfo.json_valid = $false
      }
    }

    $snapshot[$taskId] = $taskInfo
  }

  $script:taskStateSnapshot = $snapshot
  return $snapshot
}

function Get-BacklogDependencyMetadata {
  if ($null -ne $script:backlogDependencyMetadata) {
    return $script:backlogDependencyMetadata
  }

  $metadata = @{
    order        = New-Object System.Collections.Generic.List[string]
    dependencies = @{}
    has_line     = @{}
  }

  if (-not (Test-Path -LiteralPath $script:backlogPath -PathType Leaf)) {
    $script:backlogDependencyMetadata = $metadata
    return $metadata
  }

  $lines = Get-Content -LiteralPath $script:backlogPath
  $inPrioritySection = $false
  $currentTaskId = ""

  foreach ($line in $lines) {
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
      $currentTaskId = $Matches['id'].Trim()
      if (-not [string]::IsNullOrWhiteSpace($currentTaskId)) {
        $metadata.order.Add($currentTaskId) | Out-Null
        $metadata.dependencies[$currentTaskId] = @()
        $metadata.has_line[$currentTaskId] = $false
      }
      continue
    }

    if ([string]::IsNullOrWhiteSpace($currentTaskId)) {
      continue
    }

    if ($line -match '^\s*-\s*(依存|Depends on)\s*:\s*(?<value>.+?)\s*$') {
      $metadata.dependencies[$currentTaskId] = Parse-DependencyValues -RawValue $Matches['value']
      $metadata.has_line[$currentTaskId] = $true
    }
  }

  $script:backlogDependencyMetadata = $metadata
  return $metadata
}

function Get-DependencyCycleForTask {
  param(
    [string]$StartTaskId,
    [hashtable]$StateSnapshot
  )

  if (-not $StateSnapshot.ContainsKey($StartTaskId)) {
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
    if ($StateSnapshot.ContainsKey($currentTaskId)) {
      $dependencies = @($StateSnapshot[$currentTaskId].depends_on)
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

    if (-not $StateSnapshot.ContainsKey($dependencyId)) {
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

function Validate-ProcessFindings {
  param(
    [string]$ReviewContent,
    [string]$ReviewPath,
    [string]$WorkRootPath
  )

  $allowedCategories = @("flow", "docs", "ci", "quality", "other")
  $allowedSeverities = @("must", "high", "medium", "low")
  $requiredActionSeverities = @("must", "high")
  $requiredKeys = @("finding_id", "category", "severity", "summary", "evidence", "action_required")

  $processBlock = Get-HeadingBlock -Content $ReviewContent -HeadingRegex "(?m)^##\s+6\.\s+Process Findings" -EndRegex "(?m)^##\s+\d+\."
  if (-not $processBlock) {
    Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "Review must include '## 6. Process Findings'."
    return
  }

  $findingBlocks = [Regex]::Matches($processBlock, "(?ms)^###\s+6\.\d+.*?(?=^###\s+6\.\d+|\z)")
  if ($findingBlocks.Count -eq 0) {
    Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "No finding blocks found under Process Findings."
    return
  }

  foreach ($findingBlock in $findingBlocks) {
    $fields = @{}
    $keyValueMatches = [Regex]::Matches($findingBlock.Value, "(?m)^\s*-\s*([a-z_]+):\s*(.*?)\s*$")
    foreach ($match in $keyValueMatches) {
      $key = $match.Groups[1].Value.ToLowerInvariant()
      $value = Normalize-MarkdownValue -Value $match.Groups[2].Value
      $fields[$key] = $value
    }

    $hasMissingRequiredKey = $false
    foreach ($requiredKey in $requiredKeys) {
      if (-not $fields.ContainsKey($requiredKey) -or [string]::IsNullOrWhiteSpace($fields[$requiredKey])) {
        Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "Finding is missing required key: $requiredKey"
        $hasMissingRequiredKey = $true
      }
    }

    if ($hasMissingRequiredKey) {
      continue
    }

    $category = $fields["category"].ToLowerInvariant()
    if ($category -notin $allowedCategories) {
      Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "Invalid category '$category'. Allowed: $($allowedCategories -join ', ')"
    }

    $severity = $fields["severity"].ToLowerInvariant()
    if ($severity -notin $allowedSeverities) {
      Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "Invalid severity '$severity'. Allowed: $($allowedSeverities -join ', ')"
      continue
    }

    $actionRequired = $fields["action_required"].ToLowerInvariant()
    if ($actionRequired -notin @("yes", "no")) {
      Add-Failure -RuleId "improvement_findings_present" -File $ReviewPath -Reason "Invalid action_required '$actionRequired'. Allowed: yes, no"
      continue
    }

    if ($severity -in $requiredActionSeverities -and $actionRequired -ne "yes") {
      Add-Failure -RuleId "improvement_threshold_enforced" -File $ReviewPath -Reason "Severity '$severity' requires action_required: yes."
    }

    $linkedTaskId = ""
    if ($fields.ContainsKey("linked_task_id")) {
      $linkedTaskId = $fields["linked_task_id"]
    }
    if ($linkedTaskId.ToLowerInvariant() -eq "none") {
      $linkedTaskId = ""
    }

    if ($actionRequired -eq "yes") {
      if ([string]::IsNullOrWhiteSpace($linkedTaskId)) {
        Add-Failure -RuleId "improvement_task_linked" -File $ReviewPath -Reason "action_required is yes but linked_task_id is empty."
        continue
      }

      $linkedTaskPath = Join-Path -Path $WorkRootPath -ChildPath $linkedTaskId
      if (-not (Test-Path -LiteralPath $linkedTaskPath -PathType Container)) {
        Add-Failure -RuleId "improvement_task_linked" -File $ReviewPath -Reason "linked_task_id does not exist under $script:taskRootLabel/: $linkedTaskId"
      }
    }
  }
}

function Validate-CommitBoundaries {
  param(
    [string]$ReviewContent,
    [string]$ReviewPath
  )

  $commitBoundaryBlock = Get-HeadingBlock -Content $ReviewContent -HeadingRegex "(?m)^##\s+7\.\s+Commit Boundaries" -EndRegex "(?m)^##\s+\d+\."
  if (-not $commitBoundaryBlock) {
    Add-Failure -RuleId "commit_boundaries_tracked" -File $ReviewPath -Reason "state=done task requires '## 7. Commit Boundaries' in review.md."
    return
  }

  $phaseChecks = @(
    @{
      HeadingRegex = "(?m)^###\s+7\.1\s+Kickoff Commit"
      EndRegex     = "(?m)^###\s+7\.2\s+Implementation Commit|^##\s+"
      PhaseName    = "Kickoff"
    },
    @{
      HeadingRegex = "(?m)^###\s+7\.2\s+Implementation Commit"
      EndRegex     = "(?m)^###\s+7\.3\s+Finalize Commit|^##\s+"
      PhaseName    = "Implementation"
    },
    @{
      HeadingRegex = "(?m)^###\s+7\.3\s+Finalize Commit"
      EndRegex     = "(?m)^##\s+"
      PhaseName    = "Finalize"
    }
  )

  foreach ($phase in $phaseChecks) {
    $block = Get-HeadingBlock -Content $commitBoundaryBlock -HeadingRegex $phase.HeadingRegex -EndRegex $phase.EndRegex
    if (-not $block) {
      Add-Failure -RuleId "commit_boundaries_tracked" -File $ReviewPath -Reason ("Missing commit boundary section for phase: " + $phase.PhaseName)
      continue
    }

    $requiresConcreteHash = $phase.PhaseName -ne "Finalize"
    $commitPattern = if ($requiresConcreteHash) {
      "(?m)^\s*-\s*commit:\s*[0-9a-f]{7,40}\s*$"
    } else {
      "(?m)^\s*-\s*commit:\s*([0-9a-f]{7,40}|CURRENT_COMMIT)\s*$"
    }

    if (-not ([Regex]::IsMatch($block, $commitPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase))) {
      $reason = if ($requiresConcreteHash) {
        "Phase '" + $phase.PhaseName + "' requires a concrete commit hash."
      } else {
        "Phase '" + $phase.PhaseName + "' requires a commit hash or CURRENT_COMMIT."
      }
      Add-Failure -RuleId "commit_boundaries_tracked" -File $ReviewPath -Reason $reason
    }

    if (-not ([Regex]::IsMatch($block, "(?m)^\s*-\s*scope_check:\s*PASS\s*$", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase))) {
      Add-Failure -RuleId "commit_boundaries_tracked" -File $ReviewPath -Reason ("Phase '" + $phase.PhaseName + "' requires scope_check: PASS.")
    }
  }
}

function Invoke-SingleTaskCheck {
  param(
    [string]$TargetTaskId
  )

  $failures = New-Object System.Collections.Generic.List[object]
  $docQualityIssues = New-Object System.Collections.Generic.List[object]
  $referencedDocPaths = New-Object System.Collections.Generic.List[string]
  $backtick = [string][char]96
  $taskDir = Join-Path -Path $WorkRoot -ChildPath $TargetTaskId
  $requiredTaskFiles = @("request.md", "investigation.md", "spec.md", "plan.md", "review.md", "state.json")

  if (-not (Test-Path -LiteralPath $taskDir)) {
    Add-Failure -RuleId "required_files_present" -File $taskDir -Reason "Task directory does not exist."
  }

  $existingTaskFiles = @{}
  foreach ($name in $requiredTaskFiles) {
    $fullPath = Join-Path -Path $taskDir -ChildPath $name
    if (-not (Test-Path -LiteralPath $fullPath)) {
      Add-Failure -RuleId "required_files_present" -File $fullPath -Reason "Required task file is missing."
      continue
    }
    $existingTaskFiles[$name] = $fullPath
  }

  if (-not (Test-Path -LiteralPath $DocsIndexPath)) {
    Add-Failure -RuleId "docs_index_exists" -File $DocsIndexPath -Reason "Docs index is missing: $DocsIndexPath"
  }

  if (-not (Test-Path -LiteralPath $ProfilePath)) {
    Add-Failure -RuleId "profile_exists" -File $ProfilePath -Reason "project.profile.yaml is missing."
  }

  $specPath = $existingTaskFiles["spec.md"]
  $planPath = $existingTaskFiles["plan.md"]
  $reviewPath = $existingTaskFiles["review.md"]
  $statePath = $existingTaskFiles["state.json"]
  $specContent = if ($specPath) { Get-FileOrNull -Path $specPath } else { $null }
  $planContent = if ($planPath) { Get-FileOrNull -Path $planPath } else { $null }
  $reviewContent = if ($reviewPath) { Get-FileOrNull -Path $reviewPath } else { $null }
  $stateContent = if ($statePath) { Get-FileOrNull -Path $statePath } else { $null }
  $indexContent = Get-FileOrNull -Path $DocsIndexPath
  $profileContent = Get-FileOrNull -Path $ProfilePath
  $taskState = ""
  $stateObject = $null
  $dependsOn = @()
  $stateSnapshot = Get-TaskStateSnapshot
  $backlogDependencyMetadata = Get-BacklogDependencyMetadata

  function Add-DocQualityIssue {
    param(
      [string]$RuleId,
      [string]$File,
      [string]$Reason
    )

    $docQualityIssues.Add([PSCustomObject]@{
        rule_id  = $RuleId
        severity = "warning"
        file     = $File
        reason   = $Reason
      }) | Out-Null
  }

  if ($stateContent) {
    try {
      $stateObject = $stateContent | ConvertFrom-Json
      if ($stateObject -and $stateObject.PSObject.Properties.Name -contains "state") {
        $taskState = [string]$stateObject.state
      }

      if (-not ($stateObject.PSObject.Properties.Name -contains "depends_on")) {
        Add-Failure -RuleId "dependencies_declared" -File $statePath -Reason "state.json must include depends_on."
      } else {
        if ($null -eq $stateObject.depends_on) {
          Add-Failure -RuleId "dependencies_declared" -File $statePath -Reason "depends_on must be an array."
        } else {
          $dependencyIds = New-Object System.Collections.Generic.List[string]
          foreach ($rawDependencyId in @($stateObject.depends_on)) {
            $dependencyId = [string]$rawDependencyId
            if ([string]::IsNullOrWhiteSpace($dependencyId)) {
              Add-Failure -RuleId "dependencies_declared" -File $statePath -Reason "depends_on must not include empty task ids."
              continue
            }

            if ($dependencyIds.Contains($dependencyId)) {
              Add-Failure -RuleId "dependencies_declared" -File $statePath -Reason "depends_on must not include duplicate task ids: $dependencyId"
              continue
            }

            if ($dependencyId -eq $TargetTaskId) {
              Add-Failure -RuleId "dependencies_no_self" -File $statePath -Reason "depends_on must not include self task id: $dependencyId"
              continue
            }

            if (-not $stateSnapshot.ContainsKey($dependencyId)) {
              Add-Failure -RuleId "dependencies_exist" -File $statePath -Reason "depends_on references unknown task id: $dependencyId"
              continue
            }

            $dependencyInfo = $stateSnapshot[$dependencyId]
            if (-not $dependencyInfo.exists) {
              Add-Failure -RuleId "dependencies_exist" -File $statePath -Reason "depends_on references task without state.json: $dependencyId"
              continue
            }

            if (-not $dependencyInfo.json_valid) {
              Add-Failure -RuleId "dependencies_exist" -File $statePath -Reason "depends_on references task with invalid state.json: $dependencyId"
              continue
            }

            $dependencyIds.Add($dependencyId) | Out-Null
          }

          $dependsOn = $dependencyIds.ToArray()
        }
      }
    } catch {
      Add-Failure -RuleId "state_json_valid" -File $statePath -Reason "state.json is not valid JSON."
    }
  }

  if ($stateObject) {
    $cyclePath = Get-DependencyCycleForTask -StartTaskId $TargetTaskId -StateSnapshot $stateSnapshot
    if (-not [string]::IsNullOrWhiteSpace($cyclePath)) {
      Add-Failure -RuleId "dependencies_no_cycle" -File $statePath -Reason "Dependency cycle detected: $cyclePath"
    }

    if ($taskState -in @("in_progress", "done")) {
      foreach ($dependencyId in $dependsOn) {
        $dependencyState = ""
        if ($stateSnapshot.ContainsKey($dependencyId)) {
          $dependencyState = [string]$stateSnapshot[$dependencyId].state
        }
        if ($dependencyState -ne "done") {
          Add-Failure -RuleId "dependency_start_gate" -File $statePath -Reason "state=$taskState requires dependency state=done: $dependencyId (actual: $dependencyState)"
        }
      }
    }

    if ($backlogDependencyMetadata.order.Contains($TargetTaskId)) {
      $hasDependencyLine = $false
      if ($backlogDependencyMetadata.has_line.ContainsKey($TargetTaskId)) {
        $hasDependencyLine = [bool]$backlogDependencyMetadata.has_line[$TargetTaskId]
      }
      if (-not $hasDependencyLine) {
        Add-Failure -RuleId "dependency_backlog_synced" -File $script:backlogPath -Reason "Backlog entry must include dependency line: $TargetTaskId"
      } else {
        $backlogDependencies = @()
        if ($backlogDependencyMetadata.dependencies.ContainsKey($TargetTaskId)) {
          $backlogDependencies = @($backlogDependencyMetadata.dependencies[$TargetTaskId])
        }

        $normalizedStateDependencies = @($dependsOn | Sort-Object)
        $normalizedBacklogDependencies = @($backlogDependencies | Sort-Object)
        $stateDependencyFingerprint = $normalizedStateDependencies -join ","
        $backlogDependencyFingerprint = $normalizedBacklogDependencies -join ","
        if ($stateDependencyFingerprint -ne $backlogDependencyFingerprint) {
          Add-Failure -RuleId "dependency_backlog_synced" -File $script:backlogPath -Reason "Backlog dependencies do not match state.json for task: $TargetTaskId"
        }
      }
    }

    if ($DocQualityMode -ne "off" -and $backlogDependencyMetadata.order.Contains($TargetTaskId)) {
      $hasDependencyLine = $false
      if ($backlogDependencyMetadata.has_line.ContainsKey($TargetTaskId)) {
        $hasDependencyLine = [bool]$backlogDependencyMetadata.has_line[$TargetTaskId]
      }

      if (-not $hasDependencyLine) {
        Add-DocQualityIssue -RuleId "DQ-004" -File $script:backlogPath -Reason "Backlog entry does not declare dependency line for this task."
      } else {
        $backlogDependencies = @()
        if ($backlogDependencyMetadata.dependencies.ContainsKey($TargetTaskId)) {
          $backlogDependencies = @($backlogDependencyMetadata.dependencies[$TargetTaskId])
        }

        $normalizedStateDependencies = @($dependsOn | Sort-Object)
        $normalizedBacklogDependencies = @($backlogDependencies | Sort-Object)
        $stateDependencyFingerprint = $normalizedStateDependencies -join ","
        $backlogDependencyFingerprint = $normalizedBacklogDependencies -join ","
        if ($stateDependencyFingerprint -ne $backlogDependencyFingerprint) {
          Add-DocQualityIssue -RuleId "DQ-004" -File $script:backlogPath -Reason "Backlog depends_on metadata is inconsistent with state.json."
        }
      }
    }
  }

  $normalizedTaskState = $taskState.ToLowerInvariant()
  if ($normalizedTaskState -in $prerequisiteRequiredStates) {
    foreach ($requiredFileName in $prerequisiteRequiredTaskFiles) {
      if (-not $existingTaskFiles.ContainsKey($requiredFileName)) {
        continue
      }

      $requiredFilePath = $existingTaskFiles[$requiredFileName]
      $requiredFileContent = Get-FileOrNull -Path $requiredFilePath
      if (-not $requiredFileContent) {
        Add-Failure -RuleId "prerequisites_section_present" -File $requiredFilePath -Reason "Failed to read required task file."
        continue
      }

      Validate-PrerequisitesSection -Content $requiredFileContent -FilePath $requiredFilePath
    }
  }

  if ($specContent) {
    $blankKeyLineNumbers = New-Object System.Collections.Generic.List[int]
    $specLines = $specContent -split "\r?\n"
    for ($i = 0; $i -lt $specLines.Length; $i++) {
      $line = $specLines[$i]
      if (-not ($line -match "^\s*-\s*[^:\r\n]+:\s*$")) {
        continue
      }

      $nextIndex = $i + 1
      while ($nextIndex -lt $specLines.Length -and [string]::IsNullOrWhiteSpace($specLines[$nextIndex])) {
        $nextIndex++
      }

      $hasNestedList = $nextIndex -lt $specLines.Length -and ($specLines[$nextIndex] -match "^\s{2,}(-\s+\S+|\d+\.\s+\S+)")
      if (-not $hasNestedList) {
        $blankKeyLineNumbers.Add($i + 1)
      }
    }

    if ($blankKeyLineNumbers.Count -gt 0) {
      Add-Failure -RuleId "spec_required_sections_filled" -File $specPath -Reason ("Blank key-value lines were found in spec.md at lines: " + ($blankKeyLineNumbers -join ", "))
    }

    $blankBulletMatches = [Regex]::Matches($specContent, "(?m)^\s*-\s*$")
    if ($blankBulletMatches.Count -gt 0) {
      Add-Failure -RuleId "spec_required_sections_filled" -File $specPath -Reason "Blank bullet lines were found in spec.md."
    }

    $sectionChecks = @(
      @{
        HeadingRegex = "(?m)^###\s+5\.1\s+Unit Test"
        EndRegex = "(?m)^###\s+5\.2\s+Integration Test|^##\s+6\."
        Labels = @("対象", "観点", "合格条件")
      },
      @{
        HeadingRegex = "(?m)^###\s+5\.2\s+Integration Test"
        EndRegex = "(?m)^###\s+5\.3\s+Regression Test|^##\s+6\."
        Labels = @("対象", "観点", "合格条件")
      },
      @{
        HeadingRegex = "(?m)^###\s+5\.3\s+Regression Test"
        EndRegex = "(?m)^###\s+5\.4\s+Manual Verification|^##\s+6\."
        Labels = @("対象", "観点", "合格条件")
      },
      @{
        HeadingRegex = "(?m)^###\s+5\.4\s+Manual Verification"
        EndRegex = "(?m)^##\s+6\."
        Labels = @("手順", "期待結果")
      }
    )

    foreach ($check in $sectionChecks) {
      $block = Get-HeadingBlock -Content $specContent -HeadingRegex $check.HeadingRegex -EndRegex $check.EndRegex
      if (-not $block) {
        Add-Failure -RuleId "test_requirements_defined" -File $specPath -Reason "Missing required test section."
        continue
      }

      foreach ($label in $check.Labels) {
        $pattern = "(?m)^\s*-\s*" + [Regex]::Escape($label) + ":\s*\S.+$"
        if (-not ([Regex]::IsMatch($block, $pattern))) {
          Add-Failure -RuleId "test_requirements_defined" -File $specPath -Reason "Missing or blank label in test section: $label"
        }
      }
    }
  }

  if ($planContent) {
    if (-not $planContent.Contains("spec.md")) {
      Add-Failure -RuleId "plan_references_spec" -File $planPath -Reason "plan.md does not reference spec.md."
    }
  }

  if ($specContent) {
    $requiresTwoStagePlan = [Regex]::IsMatch($specContent, "(?i)plan-draft|plan-final")
    if ($requiresTwoStagePlan) {
      if (-not $planContent) {
        Add-Failure -RuleId "plan_two_stage_defined" -File $planPath -Reason "Two-stage planning is required but plan.md is missing."
      } else {
        if (-not ([Regex]::IsMatch($planContent, "(?i)plan-draft"))) {
          Add-Failure -RuleId "plan_two_stage_defined" -File $planPath -Reason "plan.md must define plan-draft when spec requires two-stage planning."
        }
        if (-not ([Regex]::IsMatch($planContent, "(?i)plan-final"))) {
          Add-Failure -RuleId "plan_two_stage_defined" -File $planPath -Reason "plan.md must define plan-final when spec requires two-stage planning."
        }
      }
    }
  }

  if ($specContent -and $indexContent) {
    $relatedLinksBlock = Get-HeadingBlock -Content $specContent -HeadingRegex "(?m)^##\s+9\.\s+関連資料リンク" -EndRegex "(?m)^##\s+"
    $docPathMatches = @()
    if ($relatedLinksBlock) {
      $docsPathPattern = '(?m)^\s*-\s+`(' + [Regex]::Escape($script:docsRootLabel) + '/[^`]+)`'
      $docPathMatches = @([Regex]::Matches($relatedLinksBlock, $docsPathPattern))
    }

    if ($docPathMatches.Count -eq 0) {
      Add-Failure -RuleId "docs_index_updated" -File $specPath -Reason "No docs path reference found in spec.md."
    } else {
      $normalizedIndexPath = Normalize-PathString -Value $DocsIndexPath
      foreach ($match in $docPathMatches) {
        $docPath = $match.Groups[1].Value
        if (-not $referencedDocPaths.Contains($docPath)) {
          $referencedDocPaths.Add($docPath) | Out-Null
        }
        if (-not (Test-Path -LiteralPath $docPath)) {
          Add-Failure -RuleId "link_targets_exist" -File $specPath -Reason "Referenced docs path does not exist: $docPath"
        }
        if ((Normalize-PathString -Value $docPath) -eq $normalizedIndexPath) {
          continue
        }
        if (-not $indexContent.Contains($docPath)) {
          Add-Failure -RuleId "docs_index_updated" -File $DocsIndexPath -Reason "Docs index does not include referenced docs path: $docPath"
        }
      }
    }
  }

  if ($DocQualityMode -ne "off" -and $referencedDocPaths.Count -gt 0) {
    $docsRefPattern = [Regex]::Escape($backtick + $script:docsRootLabel + "/") + '[^`]+' + [Regex]::Escape($backtick)
    $workRefPattern = [Regex]::Escape($backtick + $script:taskRootLabel + "/") + '[^`]+' + [Regex]::Escape($backtick)
    $normalizedIndexPath = Normalize-PathString -Value $DocsIndexPath

    foreach ($docPath in $referencedDocPaths) {
      $docContent = Get-FileOrNull -Path $docPath
      if (-not $docContent) {
        continue
      }

      $prerequisitesBlock = Get-HeadingBlock -Content $docContent -HeadingRegex "(?m)^##\s+前提知識(?:\s*\(Prerequisites.*?\))?(?:\s*\[空欄禁止\])?\s*$" -EndRegex "(?m)^##\s+"
      if (-not $prerequisitesBlock) {
        Add-DocQualityIssue -RuleId "DQ-001" -File $docPath -Reason "Missing prerequisites section."
      } else {
        $tokenMatches = [Regex]::Matches($prerequisitesBlock, '`([^`]+)`')
        $hasPathLikeReference = $false
        foreach ($tokenMatch in $tokenMatches) {
          if (Is-PathLikeToken -RawToken $tokenMatch.Groups[1].Value.Trim()) {
            $hasPathLikeReference = $true
            break
          }
        }

        if (-not $hasPathLikeReference) {
          Add-DocQualityIssue -RuleId "DQ-001" -File $docPath -Reason "Prerequisites section does not include local reference paths."
        }
      }

      $hasDocsReference = [Regex]::IsMatch($docContent, $docsRefPattern)
      $hasWorkReference = [Regex]::IsMatch($docContent, $workRefPattern)
      if (-not $hasDocsReference -or -not $hasWorkReference) {
        Add-DocQualityIssue -RuleId "DQ-002" -File $docPath -Reason "Related links should include both docs/* and work/* references."
      }

      if ((Normalize-PathString -Value $docPath) -ne $normalizedIndexPath -and -not $indexContent.Contains($docPath)) {
        Add-DocQualityIssue -RuleId "DQ-003" -File $DocsIndexPath -Reason "docs/INDEX.md does not include referenced docs path: $docPath"
      }
    }
  }

  if ($profileContent) {
    $requiredPatterns = @(
      "(?m)^\s{2}build:\s*$",
      "(?m)^\s{2}test:\s*$",
      "(?m)^\s{2}format:\s*$",
      "(?m)^\s{2}lint:\s*$",
      "(?m)^\s{2}source_roots:\s*$"
    )

    foreach ($pattern in $requiredPatterns) {
      if (-not ([Regex]::IsMatch($profileContent, $pattern))) {
        Add-Failure -RuleId "profile_required_keys" -File $ProfilePath -Reason "Missing required profile key pattern: $pattern"
      }
    }

    if ($profileContent.Contains("TODO_SET_ME")) {
      Add-Failure -RuleId "profile_required_keys" -File $ProfilePath -Reason "TODO_SET_ME remains in project.profile.yaml."
    }
  }

  if ($reviewContent) {
    $hasProcessFindingsSection = [Regex]::IsMatch($reviewContent, "(?m)^##\s+6\.\s+Process Findings")
    $shouldValidateProcessFindings = $hasProcessFindingsSection -or $taskState.ToLowerInvariant() -eq "done"
    if ($shouldValidateProcessFindings) {
      Validate-ProcessFindings -ReviewContent $reviewContent -ReviewPath $reviewPath -WorkRootPath $WorkRoot
    }

    if ($taskState.ToLowerInvariant() -eq "done") {
      $requiresCommitBoundary = $false
      if ($specContent) {
        $requiresCommitBoundary = [Regex]::IsMatch($specContent, "(?i)commit boundary|境界コミット")
      }
      if ($requiresCommitBoundary) {
        Validate-CommitBoundaries -ReviewContent $reviewContent -ReviewPath $reviewPath
      }
    }
  }

  foreach ($pair in $existingTaskFiles.GetEnumerator()) {
    $filePath = $pair.Value
    $content = Get-FileOrNull -Path $filePath
    if (-not $content) {
      continue
    }

    $linkMatches = [Regex]::Matches($content, '`([^`]+)`')
    foreach ($linkMatch in $linkMatches) {
      $raw = $linkMatch.Groups[1].Value.Trim()
      if ($raw -match "^(https?://|<task-id>|Task ID|AC-\d+)") {
        continue
      }
      if ($raw.Contains("<task-id>")) {
        continue
      }
      if ($raw.Contains(" ")) {
        continue
      }
      if ($raw.Contains("*")) {
        continue
      }
      if ($raw -match "^(pwsh|powershell)$") {
        continue
      }
      if (-not ($raw.Contains("/") -or $raw.EndsWith(".md") -or $raw.EndsWith(".yaml") -or $raw.EndsWith(".json") -or $raw.EndsWith(".ps1"))) {
        continue
      }

      $baseDir = Split-Path -Parent $filePath
      $normalized = Normalize-PathString -Value $raw
      $candidates = New-Object System.Collections.Generic.List[string]
      $candidates.Add($normalized)
      if (-not ([System.IO.Path]::IsPathRooted($normalized))) {
        $candidates.Add((Normalize-PathString -Value (Join-Path -Path $baseDir -ChildPath $normalized)))
      }

      $resolved = $false
      foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
          $resolved = $true
          break
        }
      }

      if (-not $resolved) {
        Add-Failure -RuleId "link_targets_exist" -File $filePath -Reason "Broken local reference: $normalized"
      }
    }
  }

  $effectiveFailureCount = $failures.Count
  if ($DocQualityMode -eq "fail") {
    $effectiveFailureCount += $docQualityIssues.Count
  }

  $status = if ($effectiveFailureCount -eq 0) { "PASS" } else { "FAIL" }
  return [PSCustomObject]@{
    task_id                 = $TargetTaskId
    status                  = $status
    failure_count           = $effectiveFailureCount
    failures                = $failures.ToArray()
    doc_quality_issue_count = $docQualityIssues.Count
    doc_quality_issues      = $docQualityIssues.ToArray()
  }
}

$targetTaskIds = New-Object System.Collections.Generic.List[string]
if ($PSCmdlet.ParameterSetName -eq "single") {
  $targetTaskIds.Add($TaskId) | Out-Null
} elseif ($PSCmdlet.ParameterSetName -eq "multi") {
  foreach ($rawTaskId in $TaskIds) {
    foreach ($splitTaskId in ($rawTaskId -split ",")) {
      $trimmedTaskId = $splitTaskId.Trim()
      if (-not [string]::IsNullOrWhiteSpace($trimmedTaskId) -and -not $targetTaskIds.Contains($trimmedTaskId)) {
        $targetTaskIds.Add($trimmedTaskId) | Out-Null
      }
    }
  }
} elseif ($PSCmdlet.ParameterSetName -eq "all") {
  if (-not (Test-Path -LiteralPath $WorkRoot -PathType Container)) {
    Write-Error "consistency-check: Work root does not exist: $WorkRoot"
    exit 1
  }
  $taskDirectories = Get-ChildItem -LiteralPath $WorkRoot -Directory | Sort-Object Name
  foreach ($taskDirectory in $taskDirectories) {
    if (Should-ExcludeAllTasksTarget -TaskDirectoryName $taskDirectory.Name) {
      continue
    }
    $targetTaskIds.Add($taskDirectory.Name) | Out-Null
  }
}

if ($targetTaskIds.Count -eq 0) {
  Write-Error "consistency-check: No target task IDs were resolved."
  exit 1
}

$results = New-Object System.Collections.Generic.List[object]
foreach ($targetTaskId in $targetTaskIds) {
  $results.Add((Invoke-SingleTaskCheck -TargetTaskId $targetTaskId))
}

$allFailures = New-Object System.Collections.Generic.List[object]
foreach ($result in $results) {
  foreach ($failure in $result.failures) {
    $allFailures.Add([PSCustomObject]@{
        task_id = $result.task_id
        rule_id = $failure.rule_id
        file    = $failure.file
        reason  = $failure.reason
      })
  }
}

$allDocQualityIssues = New-Object System.Collections.Generic.List[object]
foreach ($result in $results) {
  foreach ($issue in $result.doc_quality_issues) {
    $severity = if ($DocQualityMode -eq "fail") { "error" } else { "warning" }
    $allDocQualityIssues.Add([PSCustomObject]@{
        task_id  = $result.task_id
        rule_id  = $issue.rule_id
        severity = $severity
        file     = $issue.file
        reason   = $issue.reason
      }) | Out-Null
  }
}

$allEffectiveFailures = New-Object System.Collections.Generic.List[object]
foreach ($failure in $allFailures) {
  $allEffectiveFailures.Add($failure) | Out-Null
}

if ($DocQualityMode -eq "fail") {
  foreach ($issue in $allDocQualityIssues) {
    $allEffectiveFailures.Add([PSCustomObject]@{
        task_id = $issue.task_id
        rule_id = $issue.rule_id
        file    = $issue.file
        reason  = $issue.reason
      }) | Out-Null
  }
}

$docQualitySummary = [PSCustomObject]@{
  total_rules   = $docQualityRuleIds.Count
  warning_count = if ($DocQualityMode -eq "warning") { $allDocQualityIssues.Count } else { 0 }
  error_count   = if ($DocQualityMode -eq "fail") { $allDocQualityIssues.Count } else { 0 }
}

$overallStatus = if ($allEffectiveFailures.Count -eq 0) { "PASS" } else { "FAIL" }
$exitCode = if ($allEffectiveFailures.Count -eq 0) { 0 } else { 1 }

$jsonPayloadObject = if ($results.Count -eq 1) {
  $singleResult = $results[0]
  [PSCustomObject]@{
    schema_version    = $jsonSchemaVersion
    task_id           = $singleResult.task_id
    status            = $singleResult.status
    failure_count     = $singleResult.failure_count
    failures          = $singleResult.failures
    doc_quality_mode  = $DocQualityMode
    doc_quality       = $docQualitySummary
    doc_quality_issues = @($allDocQualityIssues | Where-Object { $_.task_id -eq $singleResult.task_id })
  }
} else {
  [PSCustomObject]@{
    schema_version    = $jsonSchemaVersion
    mode              = $PSCmdlet.ParameterSetName
    task_count        = $results.Count
    status            = $overallStatus
    failure_count     = $allEffectiveFailures.Count
    doc_quality_mode  = $DocQualityMode
    doc_quality       = $docQualitySummary
    doc_quality_issues = $allDocQualityIssues.ToArray()
    results           = $results.ToArray()
  }
}

if ($OutputFormat -eq "json") {
  $jsonPayload = $jsonPayloadObject | ConvertTo-Json -Depth 10
  Write-Output $jsonPayload
  if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
    $parent = Split-Path -Parent $OutputFile
    if (-not [string]::IsNullOrWhiteSpace($parent)) {
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Set-Content -LiteralPath $OutputFile -Value $jsonPayload -NoNewline
  }
  exit $exitCode
}

$textLines = New-Object System.Collections.Generic.List[string]
if ($results.Count -eq 1) {
  if ($overallStatus -eq "PASS") {
    $textLines.Add("CHECK_RESULT: PASS")
    $textLines.Add("All checks passed for task: $($results[0].task_id)")
  } else {
    $textLines.Add("CHECK_RESULT: FAIL")
    $textLines.Add("Failure Count: $($allEffectiveFailures.Count)")
    foreach ($failure in $allEffectiveFailures) {
      $textLines.Add("- rule_id=$($failure.rule_id); file=$($failure.file); reason=$($failure.reason)")
    }
  }
} else {
  $textLines.Add("CHECK_RESULT: $overallStatus")
  $textLines.Add("Task Summary:")
  foreach ($result in $results) {
    $textLines.Add("- task_id=$($result.task_id); status=$($result.status); failure_count=$($result.failure_count)")
  }

  if ($allEffectiveFailures.Count -gt 0) {
    $textLines.Add("Failure Count: $($allEffectiveFailures.Count)")
    foreach ($failure in $allEffectiveFailures) {
      $textLines.Add("- task_id=$($failure.task_id); rule_id=$($failure.rule_id); file=$($failure.file); reason=$($failure.reason)")
    }
  }
}

if ($DocQualityMode -ne "off") {
  $textLines.Add("Doc Quality Mode: $DocQualityMode")
  $textLines.Add("Doc Quality Summary: total_rules=$($docQualitySummary.total_rules); warning_count=$($docQualitySummary.warning_count); error_count=$($docQualitySummary.error_count)")
  foreach ($issue in $allDocQualityIssues) {
    if ($results.Count -eq 1) {
      $textLines.Add("- rule_id=$($issue.rule_id); severity=$($issue.severity); file=$($issue.file); reason=$($issue.reason)")
    } else {
      $textLines.Add("- task_id=$($issue.task_id); rule_id=$($issue.rule_id); severity=$($issue.severity); file=$($issue.file); reason=$($issue.reason)")
    }
  }
}

foreach ($line in $textLines) {
  Write-Output $line
}

if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
  $parent = Split-Path -Parent $OutputFile
  if (-not [string]::IsNullOrWhiteSpace($parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  Set-Content -LiteralPath $OutputFile -Value ($textLines -join [Environment]::NewLine) -NoNewline
}

exit $exitCode
