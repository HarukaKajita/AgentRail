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
$requiredStateKeys = @("state", "owner", "updated_at", "blocking_issues")
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
  if ($AllTasks) {
  $taskDirectories = Get-ChildItem -LiteralPath $WorkRoot -Directory | Sort-Object Name
  foreach ($taskDirectory in $taskDirectories) {
    Validate-Task -TargetTaskId $taskDirectory.Name
  }
  } else {
    Validate-Task -TargetTaskId $TaskId
  }
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
