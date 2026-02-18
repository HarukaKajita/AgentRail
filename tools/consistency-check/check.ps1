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
  [string]$OutputFile = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$jsonSchemaVersion = "1.0.0"

$failures = New-Object System.Collections.Generic.List[object]

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
        Add-Failure -RuleId "improvement_task_linked" -File $ReviewPath -Reason "linked_task_id does not exist under work/: $linkedTaskId"
      }
    }
  }
}

function Invoke-SingleTaskCheck {
  param(
    [string]$TargetTaskId
  )

  $failures = New-Object System.Collections.Generic.List[object]
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
    Add-Failure -RuleId "docs_index_exists" -File $DocsIndexPath -Reason "docs/INDEX.md is missing."
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

  if ($stateContent) {
    try {
      $stateObject = $stateContent | ConvertFrom-Json
      if ($stateObject -and $stateObject.PSObject.Properties.Name -contains "state") {
        $taskState = [string]$stateObject.state
      }
    } catch {
      Add-Failure -RuleId "state_json_valid" -File $statePath -Reason "state.json is not valid JSON."
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

  if ($specContent -and $indexContent) {
    $relatedLinksBlock = Get-HeadingBlock -Content $specContent -HeadingRegex "(?m)^##\s+9\.\s+関連資料リンク" -EndRegex "(?m)^##\s+"
    $docPathMatches = @()
    if ($relatedLinksBlock) {
      $docPathMatches = @([Regex]::Matches($relatedLinksBlock, '(?m)^\s*-\s+`(docs/[^`]+)`'))
    }

    if ($docPathMatches.Count -eq 0) {
      Add-Failure -RuleId "docs_index_updated" -File $specPath -Reason "No docs path reference found in spec.md."
    } else {
      $normalizedIndexPath = Normalize-PathString -Value $DocsIndexPath
      foreach ($match in $docPathMatches) {
        $docPath = $match.Groups[1].Value
        if (-not (Test-Path -LiteralPath $docPath)) {
          Add-Failure -RuleId "link_targets_exist" -File $specPath -Reason "Referenced docs path does not exist: $docPath"
        }
        if ((Normalize-PathString -Value $docPath) -eq $normalizedIndexPath) {
          continue
        }
        if (-not $indexContent.Contains($docPath)) {
          Add-Failure -RuleId "docs_index_updated" -File $DocsIndexPath -Reason "docs/INDEX.md does not include referenced docs path: $docPath"
        }
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

  $status = if ($failures.Count -eq 0) { "PASS" } else { "FAIL" }
  return [PSCustomObject]@{
    task_id       = $TargetTaskId
    status        = $status
    failure_count = $failures.Count
    failures      = $failures.ToArray()
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

$overallStatus = if ($allFailures.Count -eq 0) { "PASS" } else { "FAIL" }
$exitCode = if ($allFailures.Count -eq 0) { 0 } else { 1 }

$jsonPayloadObject = if ($results.Count -eq 1) {
  $singleResult = $results[0]
  [PSCustomObject]@{
    schema_version = $jsonSchemaVersion
    task_id        = $singleResult.task_id
    status         = $singleResult.status
    failure_count  = $singleResult.failure_count
    failures       = $singleResult.failures
  }
} else {
  [PSCustomObject]@{
    schema_version = $jsonSchemaVersion
    mode          = $PSCmdlet.ParameterSetName
    task_count    = $results.Count
    status        = $overallStatus
    failure_count = $allFailures.Count
    results       = $results.ToArray()
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
    $textLines.Add("Failure Count: $($allFailures.Count)")
    foreach ($failure in $allFailures) {
      $textLines.Add("- rule_id=$($failure.rule_id); file=$($failure.file); reason=$($failure.reason)")
    }
  }
} else {
  $textLines.Add("CHECK_RESULT: $overallStatus")
  $textLines.Add("Task Summary:")
  foreach ($result in $results) {
    $textLines.Add("- task_id=$($result.task_id); status=$($result.status); failure_count=$($result.failure_count)")
  }

  if ($allFailures.Count -gt 0) {
    $textLines.Add("Failure Count: $($allFailures.Count)")
    foreach ($failure in $allFailures) {
      $textLines.Add("- task_id=$($failure.task_id); rule_id=$($failure.rule_id); file=$($failure.file); reason=$($failure.reason)")
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
