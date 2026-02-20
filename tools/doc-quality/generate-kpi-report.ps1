param(
  [string]$ProfilePath = "project.profile.yaml",
  [string]$ConsistencyScriptPath = "tools/consistency-check/check.ps1",
  [int]$StaleThresholdDays = 14,
  [string]$OutputJsonFile = ".tmp/doc-quality-kpi-report.json",
  [string]$OutputMarkdownFile = ".tmp/doc-quality-kpi-report.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")

function Ensure-ParentDirectory {
  param([string]$PathValue)

  if ([string]::IsNullOrWhiteSpace($PathValue)) {
    return
  }

  $parent = Split-Path -Path $PathValue -Parent
  if ([string]::IsNullOrWhiteSpace($parent)) {
    return
  }

  if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
}

function Get-ConsistencyReport {
  param(
    [string]$ScriptPath
  )

  if (-not (Test-Path -LiteralPath $ScriptPath -PathType Leaf)) {
    throw "Consistency script not found: $ScriptPath"
  }

  $tempFile = Join-Path -Path $env:TEMP -ChildPath ("doc-quality-consistency-" + [Guid]::NewGuid().ToString("N") + ".json")
  try {
    $null = & pwsh -NoProfile -File $ScriptPath -AllTasks -DocQualityMode warning -OutputFormat json -OutputFile $tempFile
    if ($LASTEXITCODE -ne 0) {
      throw "Failed to collect consistency report. exit_code=$LASTEXITCODE"
    }

    if (-not (Test-Path -LiteralPath $tempFile -PathType Leaf)) {
      throw "Consistency report file was not created: $tempFile"
    }

    $jsonText = Get-Content -LiteralPath $tempFile -Raw
    return ($jsonText | ConvertFrom-Json)
  } finally {
    if (Test-Path -LiteralPath $tempFile) {
      Remove-Item -LiteralPath $tempFile -Force
    }
  }
}

function Get-StaleActiveTasks {
  param(
    [string]$TaskRoot,
    [int]$ThresholdDays
  )

  if (-not (Test-Path -LiteralPath $TaskRoot -PathType Container)) {
    throw "Task root not found: $TaskRoot"
  }

  $activeStates = @("planned", "in_progress", "blocked")
  $now = [DateTimeOffset]::Now
  $staleTasks = @()
  $activeTaskCount = 0

  $stateFiles = Get-ChildItem -LiteralPath $TaskRoot -Recurse -Filter "state.json" -File
  foreach ($stateFile in $stateFiles) {
    $content = Get-Content -LiteralPath $stateFile.FullName -Raw
    $stateObject = $content | ConvertFrom-Json

    $state = [string]$stateObject.state
    if (-not $activeStates.Contains($state)) {
      continue
    }

    $activeTaskCount += 1
    $updatedAtRaw = [string]$stateObject.updated_at
    $updatedAt = [DateTimeOffset]::MinValue
    if (-not [DateTimeOffset]::TryParse($updatedAtRaw, [ref]$updatedAt)) {
      continue
    }

    $ageDays = ($now - $updatedAt).TotalDays
    if ($ageDays -le $ThresholdDays) {
      continue
    }

    $taskId = Split-Path -Path (Split-Path -Path $stateFile.FullName -Parent) -Leaf
    $staleTasks += [PSCustomObject]@{
      task_id    = $taskId
      state      = $state
      updated_at = $updatedAtRaw
      age_days   = [Math]::Round($ageDays, 2)
    }
  }

  return [PSCustomObject]@{
    active_task_count = $activeTaskCount
    stale_tasks       = @($staleTasks)
  }
}

function Get-StaleStatus {
  param([int]$Value)

  if ($Value -eq 0) {
    return "green"
  }

  if ($Value -le 2) {
    return "yellow"
  }

  return "red"
}

function Get-LinkStatus {
  param([int]$Value)

  if ($Value -le 21) {
    return "green"
  }

  if ($Value -le 25) {
    return "yellow"
  }

  return "red"
}

function Get-CoverageStatus {
  param([double]$Value)

  if ($Value -ge 60.0) {
    return "green"
  }

  if ($Value -ge 50.0) {
    return "yellow"
  }

  return "red"
}

function New-MarkdownReport {
  param(
    [pscustomobject]$Report
  )

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("# Doc Quality KPI Report") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("- generated_at: ``$($Report.generated_at)``") | Out-Null
  $lines.Add("- overall_status: ``$($Report.summary.overall_status)``") | Out-Null
  $lines.Add("- action_required: ``$($Report.summary.action_required)``") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("## KPI") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("| KPI | Value | Threshold (green / yellow / red) | Status |") | Out-Null
  $lines.Add("| --- | --- | --- | --- |") | Out-Null

  foreach ($kpi in $Report.kpis) {
    $thresholdText = "{0} / {1} / {2}" -f $kpi.thresholds.green, $kpi.thresholds.yellow, $kpi.thresholds.red
    $valueText = if ($null -ne $kpi.unit -and $kpi.unit -ne "count") { "{0}{1}" -f $kpi.value, $kpi.unit } else { [string]$kpi.value }
    $lines.Add("| ``$($kpi.id)`` | $valueText | $thresholdText | ``$($kpi.status)`` |") | Out-Null
  }

  $lines.Add("") | Out-Null
  $lines.Add("## Guardrails") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("| Guardrail | Value | Expected | Status |") | Out-Null
  $lines.Add("| --- | --- | --- | --- |") | Out-Null
  foreach ($guardrail in $Report.guardrails) {
    $lines.Add("| ``$($guardrail.id)`` (``$($guardrail.rule_id)``) | $($guardrail.value) | $($guardrail.expected) | ``$($guardrail.status)`` |") | Out-Null
  }

  $lines.Add("") | Out-Null
  $lines.Add("## Source Summary") | Out-Null
  $lines.Add("") | Out-Null
  $lines.Add("- task_count: ``$($Report.source.task_count)``") | Out-Null
  $lines.Add("- warning_count: ``$($Report.source.warning_count)``") | Out-Null
  $lines.Add("- warning_free_task_count: ``$($Report.source.warning_free_task_count)``") | Out-Null
  $lines.Add("- warning_free_task_ratio: ``$($Report.source.warning_free_task_ratio)%``") | Out-Null
  $lines.Add("- stale_active_task_count_14d: ``$($Report.source.stale_active_task_count_14d)``") | Out-Null

  $lines.Add("") | Out-Null
  $lines.Add("## Stale Active Tasks") | Out-Null
  $lines.Add("") | Out-Null
  if (@($Report.stale_active_tasks).Count -eq 0) {
    $lines.Add("- none") | Out-Null
  } else {
    $lines.Add("| task_id | state | updated_at | age_days |") | Out-Null
    $lines.Add("| --- | --- | --- | --- |") | Out-Null
    foreach ($staleTask in $Report.stale_active_tasks) {
      $lines.Add("| ``$($staleTask.task_id)`` | ``$($staleTask.state)`` | ``$($staleTask.updated_at)`` | $($staleTask.age_days) |") | Out-Null
    }
  }

  return ($lines -join "`n")
}

$workflowPaths = Resolve-WorkflowPaths -ProfilePath $ProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
$taskRoot = $workflowPaths.task_root
$consistencyReport = Get-ConsistencyReport -ScriptPath $ConsistencyScriptPath
$staleSummary = Get-StaleActiveTasks -TaskRoot $taskRoot -ThresholdDays $StaleThresholdDays

$docQualityIssues = @($consistencyReport.doc_quality_issues)
$ruleCounts = @{
  "DQ-001" = 0
  "DQ-002" = 0
  "DQ-003" = 0
  "DQ-004" = 0
}

foreach ($issue in $docQualityIssues) {
  $ruleId = [string]$issue.rule_id
  if ($ruleCounts.ContainsKey($ruleId)) {
    $ruleCounts[$ruleId] += 1
  }
}

$taskCount = [int]$consistencyReport.task_count
$warningCount = [int]$consistencyReport.doc_quality.warning_count
$warningFreeTaskCount = @($consistencyReport.results | Where-Object { [int]$_.doc_quality_issue_count -eq 0 }).Count
$warningFreeTaskRatio = if ($taskCount -gt 0) {
  [Math]::Round(($warningFreeTaskCount / $taskCount) * 100.0, 2)
} else {
  100.0
}

$kpiFreshValue = [int]@($staleSummary.stale_tasks).Count
$kpiLinkValue = [int]$ruleCounts["DQ-002"]
$kpiCoverValue = [double]$warningFreeTaskRatio

$kpis = @(
  [PSCustomObject]@{
    id         = "KPI-FRESH-01"
    value      = $kpiFreshValue
    unit       = "count"
    status     = (Get-StaleStatus -Value $kpiFreshValue)
    thresholds = [PSCustomObject]@{
      green  = "0"
      yellow = "1-2"
      red    = ">=3"
    }
  },
  [PSCustomObject]@{
    id         = "KPI-LINK-01"
    value      = $kpiLinkValue
    unit       = "count"
    status     = (Get-LinkStatus -Value $kpiLinkValue)
    thresholds = [PSCustomObject]@{
      green  = "0-21"
      yellow = "22-25"
      red    = ">=26"
    }
  },
  [PSCustomObject]@{
    id         = "KPI-COVER-01"
    value      = $kpiCoverValue
    unit       = "%"
    status     = (Get-CoverageStatus -Value $kpiCoverValue)
    thresholds = [PSCustomObject]@{
      green  = ">=60"
      yellow = ">=50 and <60"
      red    = "<50"
    }
  }
)

$guardrails = @(
  [PSCustomObject]@{ id = "GR-001"; rule_id = "DQ-001"; value = [int]$ruleCounts["DQ-001"]; expected = 0; status = if ($ruleCounts["DQ-001"] -eq 0) { "pass" } else { "fail" } },
  [PSCustomObject]@{ id = "GR-002"; rule_id = "DQ-003"; value = [int]$ruleCounts["DQ-003"]; expected = 0; status = if ($ruleCounts["DQ-003"] -eq 0) { "pass" } else { "fail" } },
  [PSCustomObject]@{ id = "GR-003"; rule_id = "DQ-004"; value = [int]$ruleCounts["DQ-004"]; expected = 0; status = if ($ruleCounts["DQ-004"] -eq 0) { "pass" } else { "fail" } }
)

$redKpiCount = @($kpis | Where-Object { $_.status -eq "red" }).Count
$yellowKpiCount = @($kpis | Where-Object { $_.status -eq "yellow" }).Count
$guardrailFailCount = @($guardrails | Where-Object { $_.status -eq "fail" }).Count

$overallStatus = "green"
if ($guardrailFailCount -gt 0 -or $redKpiCount -gt 0) {
  $overallStatus = "red"
} elseif ($yellowKpiCount -gt 0) {
  $overallStatus = "yellow"
}

$report = [PSCustomObject]@{
  schema_version = "1.0.0"
  generated_at   = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssK")
  source         = [PSCustomObject]@{
    task_root                     = $taskRoot
    task_count                    = $taskCount
    warning_count                 = $warningCount
    warning_free_task_count       = $warningFreeTaskCount
    warning_free_task_ratio       = $warningFreeTaskRatio
    stale_active_task_count_14d   = $kpiFreshValue
    rule_counts                   = [PSCustomObject]$ruleCounts
  }
  baseline       = [PSCustomObject]@{
    captured_on              = "2026-02-20"
    task_count               = 56
    dq002_warning_count      = 21
    warning_free_task_ratio  = 62.5
  }
  kpis                = $kpis
  guardrails          = $guardrails
  stale_active_tasks  = @($staleSummary.stale_tasks)
  summary             = [PSCustomObject]@{
    overall_status       = $overallStatus
    action_required      = ($overallStatus -ne "green")
    red_kpi_count        = $redKpiCount
    yellow_kpi_count     = $yellowKpiCount
    guardrail_fail_count = $guardrailFailCount
  }
}

Ensure-ParentDirectory -PathValue $OutputJsonFile
Ensure-ParentDirectory -PathValue $OutputMarkdownFile

$report | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputJsonFile
(New-MarkdownReport -Report $report) | Set-Content -Path $OutputMarkdownFile

Write-Output "DOC_QUALITY_REPORT: PASS"
Write-Output "JSON: $OutputJsonFile"
Write-Output "Markdown: $OutputMarkdownFile"
Write-Output "overall_status=$overallStatus"
Write-Output "kpi_fresh_01=$kpiFreshValue"
Write-Output "kpi_link_01=$kpiLinkValue"
Write-Output "kpi_cover_01=$kpiCoverValue"
