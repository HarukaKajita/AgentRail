param(
  [Parameter(Mandatory = $true)]
  [string]$TaskId,
  [string]$WorkRoot = "work",
  [string]$DocsIndexPath = "docs/INDEX.md",
  [string]$ProfilePath = "project.profile.yaml"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

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

$taskDir = Join-Path -Path $WorkRoot -ChildPath $TaskId
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
$specContent = if ($specPath) { Get-FileOrNull -Path $specPath } else { $null }
$planContent = if ($planPath) { Get-FileOrNull -Path $planPath } else { $null }
$indexContent = Get-FileOrNull -Path $DocsIndexPath
$profileContent = Get-FileOrNull -Path $ProfilePath

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
  $docPathMatches = if ($relatedLinksBlock) {
    [Regex]::Matches($relatedLinksBlock, '(?m)^\s*-\s+`(docs/[^`]+)`')
  } else {
    [Regex]::Matches("", ".")
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

if ($failures.Count -eq 0) {
  Write-Output "CHECK_RESULT: PASS"
  Write-Output "All checks passed for task: $TaskId"
  exit 0
}

Write-Output "CHECK_RESULT: FAIL"
Write-Output "Failure Count: $($failures.Count)"
foreach ($failure in $failures) {
  Write-Output "- rule_id=$($failure.rule_id); file=$($failure.file); reason=$($failure.reason)"
}
exit 1
