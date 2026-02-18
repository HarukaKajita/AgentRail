param(
  [Parameter(Mandatory = $true)]
  [string]$TaskId,
  [string]$WorkRoot = "work"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([string]$Message)
  Write-Error "improvement-scan: $Message"
  exit 1
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

$allowedCategories = @("flow", "docs", "ci", "quality", "other")
$allowedSeverities = @("must", "high", "medium", "low")
$requiredActionSeverities = @("must", "high")
$requiredKeys = @("finding_id", "category", "severity", "summary", "evidence", "action_required")

$taskDir = Join-Path -Path $WorkRoot -ChildPath $TaskId
$reviewPath = Join-Path -Path $taskDir -ChildPath "review.md"

if (-not (Test-Path -LiteralPath $taskDir -PathType Container)) {
  Fail("Task directory does not exist: $taskDir")
}

if (-not (Test-Path -LiteralPath $reviewPath -PathType Leaf)) {
  Fail("review.md does not exist: $reviewPath")
}

$reviewContent = Get-Content -LiteralPath $reviewPath -Raw
$processBlock = Get-HeadingBlock -Content $reviewContent -HeadingRegex "(?m)^##\s+6\.\s+Process Findings" -EndRegex "(?m)^##\s+\d+\."
if (-not $processBlock) {
  Fail("Missing '## 6. Process Findings' section in review.md")
}

$findingBlocks = [Regex]::Matches($processBlock, "(?ms)^###\s+6\.\d+.*?(?=^###\s+6\.\d+|\z)")
if ($findingBlocks.Count -eq 0) {
  Fail("No finding blocks found under Process Findings")
}

$findings = @()

foreach ($findingBlock in $findingBlocks) {
  $fields = @{}
  $keyValueMatches = [Regex]::Matches($findingBlock.Value, "(?m)^\s*-\s*([a-z_]+):\s*(.*?)\s*$")
  foreach ($match in $keyValueMatches) {
    $key = $match.Groups[1].Value.ToLowerInvariant()
    $value = Normalize-MarkdownValue -Value $match.Groups[2].Value
    $fields[$key] = $value
  }

  foreach ($requiredKey in $requiredKeys) {
    if (-not $fields.ContainsKey($requiredKey) -or [string]::IsNullOrWhiteSpace($fields[$requiredKey])) {
      Fail("Finding is missing required key: $requiredKey")
    }
  }

  $category = $fields["category"].ToLowerInvariant()
  if ($category -notin $allowedCategories) {
    Fail("Invalid category '$category'. Allowed: $($allowedCategories -join ', ')")
  }

  $severity = $fields["severity"].ToLowerInvariant()
  if ($severity -notin $allowedSeverities) {
    Fail("Invalid severity '$severity'. Allowed: $($allowedSeverities -join ', ')")
  }

  $actionRequired = $fields["action_required"].ToLowerInvariant()
  if ($actionRequired -notin @("yes", "no")) {
    Fail("Invalid action_required '$actionRequired'. Allowed: yes, no")
  }

  $linkedTaskId = ""
  if ($fields.ContainsKey("linked_task_id")) {
    $linkedTaskId = $fields["linked_task_id"]
  }
  if ($linkedTaskId.ToLowerInvariant() -eq "none") {
    $linkedTaskId = ""
  }

  if ($severity -in $requiredActionSeverities -and $actionRequired -ne "yes") {
    Fail("Severity '$severity' requires action_required: yes")
  }

  if ($actionRequired -eq "yes") {
    if ([string]::IsNullOrWhiteSpace($linkedTaskId)) {
      Fail("action_required is yes but linked_task_id is empty")
    }

    $linkedTaskPath = Join-Path -Path $WorkRoot -ChildPath $linkedTaskId
    if (-not (Test-Path -LiteralPath $linkedTaskPath -PathType Container)) {
      Fail("linked_task_id does not exist under work/: $linkedTaskId")
    }
  }

  $linkedTaskValue = if ([string]::IsNullOrWhiteSpace($linkedTaskId)) { "none" } else { $linkedTaskId }
  $finding = [PSCustomObject]@{
    finding_id      = $fields["finding_id"]
    category        = $category
    severity        = $severity
    summary         = $fields["summary"]
    evidence        = $fields["evidence"]
    action_required = $actionRequired
    linked_task_id  = $linkedTaskValue
  }

  $findings += $finding
}

$result = [PSCustomObject]@{
  task_id       = $TaskId
  finding_count = $findings.Count
  findings      = $findings
}

$result | ConvertTo-Json -Depth 5
exit 0
