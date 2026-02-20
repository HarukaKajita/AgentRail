param(
  [Parameter(Mandatory = $true)]
  [string]$SourceTaskId,
  [string]$ReportJsonPath = ".tmp/doc-quality-kpi-report.json",
  [string]$FindingId = "F-KPI-001",
  [string]$SuggestedLinkedTaskId = "<new-task-id>",
  [ValidateSet("text", "json")]
  [string]$OutputFormat = "text"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ReportJsonPath -PathType Leaf)) {
  throw "Report JSON was not found: $ReportJsonPath"
}

$report = Get-Content -LiteralPath $ReportJsonPath -Raw | ConvertFrom-Json
$overallStatus = [string]$report.summary.overall_status

$severity = "low"
$actionRequired = "no"
$title = "KPI monitoring is healthy"
if ($overallStatus -eq "yellow") {
  $severity = "medium"
  $actionRequired = "yes"
  $title = "Address KPI warning trend"
} elseif ($overallStatus -eq "red") {
  $severity = "high"
  $actionRequired = "yes"
  $title = "Recover doc quality KPI regression"
}

$kpiStatuses = @($report.kpis | ForEach-Object { "{0}={1}" -f $_.id, $_.status }) -join ", "
$generatedAtText = if ($report.generated_at -is [datetime]) {
  ([datetime]$report.generated_at).ToString("yyyy-MM-ddTHH:mm:ssK")
} else {
  [string]$report.generated_at
}
$summary = if ($actionRequired -eq "yes") {
  "Doc quality KPI report status is $overallStatus."
} else {
  "Doc quality KPI report is green and no immediate action is required."
}
$evidence = "report=$ReportJsonPath; generated_at=$generatedAtText; kpis=$kpiStatuses"

$linkedTaskId = if ($actionRequired -eq "yes") { $SuggestedLinkedTaskId } else { "none" }

$finding = [PSCustomObject]@{
  finding_id      = $FindingId
  category        = "quality"
  severity        = $severity
  summary         = $summary
  evidence        = $evidence
  action_required = $actionRequired
  linked_task_id  = $linkedTaskId
  suggested_title = $title
}

if ($OutputFormat -eq "json") {
  $finding | ConvertTo-Json -Depth 5
  exit 0
}

Write-Output "### 6.x Finding $($finding.finding_id)"
Write-Output "- finding_id: $($finding.finding_id)"
Write-Output "- category: $($finding.category)"
Write-Output "- severity: $($finding.severity)"
Write-Output "- summary: $($finding.summary)"
Write-Output "- evidence: $($finding.evidence)"
Write-Output "- action_required: $($finding.action_required)"
Write-Output "- linked_task_id: $($finding.linked_task_id)"

if ($actionRequired -eq "yes") {
  Write-Output ""
  Write-Output "# Suggested create-task command"
  Write-Output "pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId $SourceTaskId -FindingId $FindingId -Title '$title' -Severity $severity -Category quality -TaskId $SuggestedLinkedTaskId"
}
