param(
  [Parameter(Mandatory = $true)]
  [string]$ProposalsPath,
  [string]$RepoRoot = ".",
  [string]$ProfilePath = "project.profile.yaml",
  [string]$Owner = "unassigned",
  [switch]$DryRun,
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")

function Fail {
  param([string]$Message)
  Write-Error "onboarding-apply: $Message"
  exit 1
}

function Normalize-RepoRelPath {
  param(
    [string]$RepoRootFullPath,
    [string]$FullPath
  )
  $rel = [System.IO.Path]::GetRelativePath($RepoRootFullPath, $FullPath)
  return (ConvertTo-NormalizedRepoPath -PathValue $rel)
}

function Require-NonEmptyString {
  param(
    [string]$Value,
    [string]$Label
  )
  if ([string]::IsNullOrWhiteSpace($Value)) {
    Fail("missing required field: $Label")
  }
}

function Read-JsonFile {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Fail("JSON file not found: $Path")
  }
  try {
    return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -Depth 20)
  } catch {
    Fail("failed to parse JSON: $Path")
  }
}

function Format-DependencyLine {
  param([string[]]$DependsOn)
  $backtick = [string][char]96
  if ($null -eq $DependsOn -or $DependsOn.Count -eq 0) {
    return "なし"
  }
  return ($DependsOn | ForEach-Object { "$backtick$($_)$backtick" }) -join ", "
}

function Get-DependencyGateState {
  param(
    [string]$WorkRoot,
    [string[]]$DependsOn
  )

  if ($null -eq $DependsOn -or $DependsOn.Count -eq 0) {
    return [PSCustomObject]@{ gate = "plan-ready"; status = "なし" }
  }

  $allDone = $true
  foreach ($dep in $DependsOn) {
    $depId = [string]$dep
    if ([string]::IsNullOrWhiteSpace($depId)) { continue }
    $depStatePath = Join-Path -Path (Join-Path -Path $WorkRoot -ChildPath $depId.Trim()) -ChildPath "state.json"
    if (-not (Test-Path -LiteralPath $depStatePath -PathType Leaf)) {
      $allDone = $false
      continue
    }
    try {
      $stateObj = Get-Content -LiteralPath $depStatePath -Raw | ConvertFrom-Json -Depth 10
      if ($null -eq $stateObj -or [string]$stateObj.state -ne "done") {
        $allDone = $false
      }
    } catch {
      $allDone = $false
    }
  }

  if ($allDone) {
    return [PSCustomObject]@{ gate = "plan-ready"; status = "解決済み" }
  }
  return [PSCustomObject]@{ gate = "dependency-blocked"; status = "未解決" }
}

function Group-TestsByKind {
  param($Tests)
  $groups = @{
    unit = @()
    integration = @()
    regression = @()
    manual = @()
  }
  foreach ($t in @($Tests)) {
    if ($null -eq $t) { continue }
    $kind = [string]$t.kind
    if (-not $groups.ContainsKey($kind)) {
      continue
    }
    $groups[$kind] += $t
  }
  return $groups
}

function Ensure-Directory {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path -PathType Container) {
    return
  }
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Upsert-Backlog {
  param(
    [string]$BacklogPath,
    [PSCustomObject[]]$Entries,
    [string]$WorkRootLabel
  )

  $backtick = [string][char]96

  if (-not (Test-Path -LiteralPath $BacklogPath -PathType Leaf)) {
    Fail("backlog file not found: $BacklogPath")
  }

  $content = Get-Content -LiteralPath $BacklogPath -Raw
  $newline = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }

  $prefixStart = -1
  $bodyStart = -1
  $bodyEnd = -1
  $prefix = ""
  $existingBody = ""

  $pattern = "(?ms)(^##\\s+優先タスク一覧\\s*\\r?\\n)(.*?)(?=^##\\s+Completed\\b|\\z)"
  $match = [Regex]::Match($content, $pattern)
  if ($match.Success) {
    $prefix = $match.Groups[1].Value
    $existingBody = $match.Groups[2].Value
    $prefixStart = $match.Index
    $bodyStart = $match.Index + $prefix.Length
    $bodyEnd = $bodyStart + $existingBody.Length
  } else {
    # Fallback parser: avoid brittle regex issues across encodings/newlines.
    $prefixStart = $content.IndexOf("## 優先タスク一覧", [System.StringComparison]::OrdinalIgnoreCase)
    if ($prefixStart -lt 0) {
      Fail("failed to locate backlog section: 優先タスク一覧")
    }

    $lineEnd = $content.IndexOf("`n", $prefixStart, [System.StringComparison]::Ordinal)
    if ($lineEnd -lt 0) {
      Fail("failed to parse backlog section heading line: 優先タスク一覧")
    }
    $bodyStart = $lineEnd + 1
    $prefix = $content.Substring($prefixStart, $bodyStart - $prefixStart)

    $bodyEnd = $content.IndexOf("## Completed", $bodyStart, [System.StringComparison]::OrdinalIgnoreCase)
    if ($bodyEnd -lt 0) {
      $bodyEnd = $content.Length
    }
    $existingBody = $content.Substring($bodyStart, $bodyEnd - $bodyStart)
  }

  $existingLines = @($existingBody -split "`r?`n")
  $existingTaskIds = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($line in $existingLines) {
    $m = [Regex]::Match($line, '^\s*-\s+`?([0-9]{4}-[0-9]{2}-[0-9]{2}__[^`\\s]+)`?\s*$')
    if ($m.Success) {
      [void]$existingTaskIds.Add($m.Groups[1].Value.Trim())
    }
  }

  $blocks = New-Object System.Collections.Generic.List[string]
  foreach ($entry in $Entries) {
    $taskId = [string]$entry.task_id
    if ([string]::IsNullOrWhiteSpace($taskId)) { continue }
    if ($existingTaskIds.Contains($taskId)) {
      continue
    }

    $depends = @($entry.depends_on | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $gate = Get-DependencyGateState -WorkRoot $entry.work_root -DependsOn $depends
    $blocks.Add("- $backtick$taskId$backtick") | Out-Null
    $blocks.Add("- 状態: planned") | Out-Null
    $blocks.Add("- 計画段階: plan-draft") | Out-Null
    $blocks.Add("- ゲート状態: $($gate.gate)") | Out-Null
    $blocks.Add("- 依存: $(Format-DependencyLine -DependsOn $depends)") | Out-Null
    $blocks.Add("- 依存状態: $($gate.status)") | Out-Null
    $blocks.Add("- 目的: $([string]$entry.title)") | Out-Null
    $specPathLabel = Join-NormalizedRepoPath -BasePath (Join-NormalizedRepoPath -BasePath $WorkRootLabel -ChildPath $taskId) -ChildPath 'spec.md'
    $blocks.Add("- 参照: $backtick$specPathLabel$backtick") | Out-Null
    $blocks.Add("") | Out-Null
  }

  $newBody = ""
  if ($blocks.Count -eq 0) {
    $newBody = $existingBody
  } else {
    $trimmedExisting = $existingBody.Trim()
    if ($trimmedExisting -eq "- なし" -or [string]::IsNullOrWhiteSpace($trimmedExisting)) {
      $newBody = ($blocks -join $newline) + $newline
    } else {
      $newBody = ($blocks -join $newline) + $newline + $existingBody.TrimStart()
      if (-not $newBody.EndsWith($newline)) { $newBody += $newline }
    }
  }

  if ($prefixStart -ge 0 -and $bodyStart -ge 0 -and $bodyEnd -ge $bodyStart) {
    $before = $content.Substring(0, $bodyStart)
    $after = $content.Substring($bodyEnd)
    return $before + $newBody + $after
  }

  Fail("failed to update backlog section due to parser error.")
}

function Append-MemoryNote {
  param(
    [string]$MemoryPath,
    [PSCustomObject[]]$Entries
  )

  if (-not (Test-Path -LiteralPath $MemoryPath -PathType Leaf)) {
    return $null
  }

  $content = Get-Content -LiteralPath $MemoryPath -Raw
  $newline = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("## Generated Tasks (Onboarding)") | Out-Null
  $lines.Add("") | Out-Null
  foreach ($e in $Entries) {
    $lines.Add("- `"$([string]$e.task_id)`": $([string]$e.title)") | Out-Null
  }
  $lines.Add("") | Out-Null
  $lines.Add("generated_at: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ssK")") | Out-Null
  $lines.Add("") | Out-Null

  if ($content.TrimEnd().EndsWith("## Notes")) {
    # Avoid accidentally nesting under a heading-only tail.
    return ($content.TrimEnd() + $newline + $newline + ($lines -join $newline) + $newline)
  }

  return ($content.TrimEnd() + $newline + $newline + ($lines -join $newline) + $newline)
}

$repoRootFull = (Resolve-Path -LiteralPath $RepoRoot).Path
if (-not (Test-Path -LiteralPath $repoRootFull -PathType Container)) {
  Fail("RepoRoot does not exist: $RepoRoot")
}

$proposalsCandidate = $ProposalsPath
if (-not [System.IO.Path]::IsPathRooted($proposalsCandidate)) {
  $proposalsCandidate = Join-Path -Path $repoRootFull -ChildPath $proposalsCandidate
}
if (-not (Test-Path -LiteralPath $proposalsCandidate -PathType Leaf)) {
  Fail("JSON file not found: $proposalsCandidate")
}
$proposalsFull = (Resolve-Path -LiteralPath $proposalsCandidate).Path
$root = Read-JsonFile -Path $proposalsFull

Require-NonEmptyString -Value ([string]$root.schema_version) -Label "schema_version"
if ($null -eq $root.proposals) {
  Fail("missing required field: proposals")
}

$resolvedProfilePath = Join-Path -Path $repoRootFull -ChildPath $ProfilePath
Push-Location -LiteralPath $repoRootFull
try {
  $workflowPaths = Resolve-WorkflowPaths -ProfilePath $resolvedProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
} finally {
  Pop-Location
}

$workRoot = Join-Path -Path $repoRootFull -ChildPath $workflowPaths.task_root
$docsRoot = Join-Path -Path $repoRootFull -ChildPath $workflowPaths.docs_root
$docsIndexPath = Join-Path -Path $repoRootFull -ChildPath $workflowPaths.docs_index_path
$backlogPath = Join-Path -Path $repoRootFull -ChildPath $workflowPaths.backlog_path
$memoryPath = Join-Path -Path $repoRootFull -ChildPath "MEMORY.md"

if (-not (Test-Path -LiteralPath $docsIndexPath -PathType Leaf)) {
  Fail("docs/INDEX.md not found (required): $docsIndexPath")
}
if (-not (Test-Path -LiteralPath $backlogPath -PathType Leaf)) {
  Fail("backlog not found (required): $backlogPath")
}

$nowIso = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"
$today = Get-Date -Format "yyyy-MM-dd"
$backtick = [string][char]96

$entries = New-Object System.Collections.Generic.List[object]
$allProposalTaskIds = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

foreach ($proposal in @($root.proposals)) {
  if ($null -eq $proposal) { continue }
  $rawId = [string]$proposal.task_id
  if ([string]::IsNullOrWhiteSpace($rawId)) { continue }
  [void]$allProposalTaskIds.Add($rawId.Trim())
}

foreach ($proposal in @($root.proposals)) {
  if ($null -eq $proposal) { continue }

  $taskId = [string]$proposal.task_id
  $title = [string]$proposal.title
  $rationale = [string]$proposal.rationale
  $priority = [string]$proposal.priority
  $dependsOn = @($proposal.depends_on | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

  Require-NonEmptyString -Value $taskId -Label "proposals[].task_id"
  Require-NonEmptyString -Value $title -Label "proposals[].title"
  Require-NonEmptyString -Value $rationale -Label "proposals[].rationale"
  if ($priority -notin @("P0", "P1", "P2", "P3")) {
    Fail("invalid priority for ${taskId}: $priority (expected P0|P1|P2|P3)")
  }

  $taskDir = Join-Path -Path $workRoot -ChildPath $taskId
  if ((Test-Path -LiteralPath $taskDir) -and (-not $Force)) {
    Fail("task already exists: $taskDir (use -Force to overwrite)")
  }

  foreach ($depId in $dependsOn) {
    $depTrimmed = $depId.Trim()
    if ([string]::IsNullOrWhiteSpace($depTrimmed)) { continue }
    if ($depTrimmed -eq $taskId) {
      Fail("depends_on must not include the task itself: $taskId")
    }

    if ($allProposalTaskIds.Contains($depTrimmed)) {
      continue
    }

    $depStatePath = Join-Path -Path (Join-Path -Path $workRoot -ChildPath $depTrimmed) -ChildPath "state.json"
    if (-not (Test-Path -LiteralPath $depStatePath -PathType Leaf)) {
      Fail("depends_on references missing task (not in proposals and no existing state.json): $depTrimmed")
    }
  }

  $docActions = @($proposal.doc_actions)
  if ($null -eq $docActions -or $docActions.Count -eq 0) {
    Fail("doc_actions must be non-empty: $taskId")
  }

  $acList = @($proposal.acceptance_criteria)
  if ($null -eq $acList -or $acList.Count -eq 0) {
    Fail("acceptance_criteria must be non-empty: $taskId")
  }

  $testsList = @($proposal.tests)
  if ($null -eq $testsList -or $testsList.Count -eq 0) {
    Fail("tests must be non-empty: $taskId")
  }

  $deliverables = @($proposal.deliverables)
  $testsByKind = Group-TestsByKind -Tests $testsList

  $taskRootLabel = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.task_root
  $docsRootLabel = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.docs_root
  $docsIndexLabel = Join-NormalizedRepoPath -BasePath $docsRootLabel -ChildPath "INDEX.md"
  $backlogLabel = Join-NormalizedRepoPath -BasePath $docsRootLabel -ChildPath "operations/high-priority-backlog.md"

  $taskRootLabel2 = Join-NormalizedRepoPath -BasePath $taskRootLabel -ChildPath $taskId
  $requestPathLabel = Join-NormalizedRepoPath -BasePath $taskRootLabel2 -ChildPath "request.md"
  $investigationPathLabel = Join-NormalizedRepoPath -BasePath $taskRootLabel2 -ChildPath "investigation.md"
  $specPathLabel = Join-NormalizedRepoPath -BasePath $taskRootLabel2 -ChildPath "spec.md"
  $planPathLabel = Join-NormalizedRepoPath -BasePath $taskRootLabel2 -ChildPath "plan.md"
  $reviewPathLabel = Join-NormalizedRepoPath -BasePath $taskRootLabel2 -ChildPath "review.md"

  $runbookDoc = Join-NormalizedRepoPath -BasePath $docsRootLabel -ChildPath "operations/onboarding-existing-repo-document-inventory-runbook.md"
  $schemaDoc = Join-NormalizedRepoPath -BasePath $docsRootLabel -ChildPath "operations/onboarding-task-proposals-json-format.md"

  $dependencyLabel = Format-DependencyLine -DependsOn $dependsOn

  $docActionLines = New-Object System.Collections.Generic.List[string]
  foreach ($action in $docActions) {
    $kind = [string]$action.kind
    $targetPath = [string]$action.target.path
    if ([string]::IsNullOrWhiteSpace($kind) -or [string]::IsNullOrWhiteSpace($targetPath)) {
      Fail("invalid doc_actions entry for $taskId (kind/target.path required)")
    }
    $docActionLines.Add("- ${kind}: $targetPath") | Out-Null
  }

  $deliverableLines = New-Object System.Collections.Generic.List[string]
  foreach ($d in $deliverables) {
    if ($null -eq $d) { continue }
    $deliverableLines.Add("- $([string]$d.type): $([string]$d.path)") | Out-Null
  }

  if ($deliverableLines.Count -eq 0) {
    $deliverableLines.Add("- (none)") | Out-Null
  }

  $acLines = New-Object System.Collections.Generic.List[string]
  foreach ($ac in $acList) {
    $acId = [string]$ac.id
    $acText = [string]$ac.text
    if ([string]::IsNullOrWhiteSpace($acId) -or [string]::IsNullOrWhiteSpace($acText)) {
      Fail("invalid acceptance_criteria entry for $taskId (id/text required)")
    }
    $acLines.Add("- ${acId}: $acText") | Out-Null
  }

  function Build-TestSection {
    param(
      [string]$KindLabel,
      $Tests
    )

    $lines = New-Object System.Collections.Generic.List[string]
    if ($null -eq $Tests -or @($Tests).Count -eq 0) {
      $lines.Add("- 対象: N/A") | Out-Null
      $lines.Add("- 観点: N/A") | Out-Null
      $lines.Add("- 合格条件: N/A") | Out-Null
      return $lines
    }

    $lines.Add("- 対象: $KindLabel") | Out-Null
    $lines.Add("- 観点: 提案 JSON の tests.$KindLabel を実行可能な形へ落とし込めている") | Out-Null

    $caseLines = New-Object System.Collections.Generic.List[string]
    foreach ($t in @($Tests)) {
      $steps = [string]$t.command_or_steps
      $pass = [string]$t.pass_criteria
      if ([string]::IsNullOrWhiteSpace($steps)) { $steps = "(missing steps)" }
      if ([string]::IsNullOrWhiteSpace($pass)) { $pass = "(missing pass criteria)" }
      $caseLines.Add("- steps: $steps") | Out-Null
      $caseLines.Add("- pass: $pass") | Out-Null
    }

    $lines.Add("- 合格条件: 上記 steps を実行し、pass が満たされる") | Out-Null
    $lines.AddRange($caseLines) | Out-Null
    return $lines
  }

  $unitLines = Build-TestSection -KindLabel "unit" -Tests $testsByKind.unit
  $integrationLines = Build-TestSection -KindLabel "integration" -Tests $testsByKind.integration
  $regressionLines = Build-TestSection -KindLabel "regression" -Tests $testsByKind.regression
  $manualLines = Build-TestSection -KindLabel "manual" -Tests $testsByKind.manual

  $requestContent = @(
    "# Request: $taskId",
    "",
    "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
    "",
    "- 参照資料:",
    "  - ${backtick}AGENTS.md${backtick}",
    "  - ${backtick}$docsIndexLabel${backtick}",
    "  - ${backtick}$runbookDoc${backtick}",
    "  - ${backtick}$schemaDoc${backtick}",
    "  - ${backtick}$backlogLabel${backtick}",
    "- 理解ポイント:",
    "  - 本タスクは onboarding 提案 JSON から機械的に起票された。内容の妥当性は人間が review して確定する。",
    "",
    "## 1. 要望",
    "",
    "- タイトル: $title",
    "- 背景/意図: $rationale",
    "- 優先度: $priority",
    "- depends_on: $dependencyLabel",
    "",
    "## 2. docs 操作（提案）",
    "",
    ($docActionLines -join "`n"),
    "",
    "## 3. 期待する成果物",
    "",
    ($deliverableLines -join "`n")
  ) -join "`n"

  $investigationContent = @(
    "# Investigation: $taskId",
    "",
    "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
    "",
    "- 参照資料:",
    "  - ${backtick}AGENTS.md${backtick}",
    "  - ${backtick}$docsIndexLabel${backtick}",
    "  - ${backtick}$requestPathLabel${backtick}",
    "- 理解ポイント:",
    "  - 観測方法と観測結果を分離し、事実ベースで結論を出す。",
    "",
    "## 1. 仮説",
    "",
    "- PENDING: $title を達成するために必要な最小の docs/実装変更を仮説として列挙する。",
    "",
    "## 2. 観測方法（Observation Method / 観測方法）",
    "",
    "- PENDING: 対象ファイルをどう読むか、どう差分を確認するか。",
    "",
    "## 3. 観測結果（Observation Result / 観測結果）",
    "",
    "- PENDING: 実際に確認した事実を記録する。",
    "",
    "## 4. 結論",
    "",
    "- PENDING: 仮説と観測結果からの結論。"
  ) -join "`n"

  $specContent = @(
    "# 仕様書: $taskId",
    "",
    "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
    "",
    "- 参照資料:",
    "  - ${backtick}AGENTS.md${backtick}",
    "  - ${backtick}$docsIndexLabel${backtick}",
    "  - ${backtick}$runbookDoc${backtick}",
    "  - ${backtick}$schemaDoc${backtick}",
    "- 理解ポイント:",
    "  - 本仕様は onboarding 提案 JSON を起点にしている。必要に応じてスコープと受入条件を調整する。",
    "",
    "## 1. メタ情報 [空欄禁止]",
    "",
    "- Task ID: $taskId",
    "- タイトル: $title",
    "- 作成日: $today",
    "- 更新日: $today",
    "- 作成者: onboarding/apply-task-proposals.ps1",
    "- 関連要望: ${backtick}$requestPathLabel${backtick}",
    "",
    "## 2. 背景と目的 [空欄禁止]",
    "",
    "- 背景: $rationale",
    "- 目的: $title を実施し、docs 整合と導線を回復する。",
    "",
    "## 3. スコープ [空欄禁止]",
    "",
    "### 3.1 In Scope [空欄禁止]",
    "",
    ($docActionLines -join "`n"),
    "",
    "### 3.2 Out of Scope [空欄禁止]",
    "",
    "- 本タスク外の docs/実装の過剰改変（必要なら別タスクへ分割）。",
    "",
    "## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]",
    "",
    ($acLines -join "`n"),
    "",
    "## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]",
    "",
    "### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]",
    "",
    ($unitLines -join "`n"),
    "",
    "### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]",
    "",
    ($integrationLines -join "`n"),
    "",
    "### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]",
    "",
    ($regressionLines -join "`n"),
    "",
    "### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]",
    "",
    ($manualLines -join "`n"),
    "",
    "## 6. 影響範囲 [空欄禁止]",
    "",
    "- 影響ファイル/モジュール: PENDING（investigation で確定）",
    "- 影響する仕様: PENDING（必要に応じて追加）",
    "- 非機能影響: docs 整合性と導線の改善",
    "",
    "## 7. 制約とリスク [空欄禁止]",
    "",
    "- 制約: 適用側スクリプトは決定を持たない（命名/優先度判断は提案 JSON と人間確認に委ねる）。",
    "- 想定リスク: 提案 JSON の誤りにより不要なタスクが混入する。",
    "- 回避策: `-DryRun` で PLAN を確認し、必要なら JSON を修正してから適用する。",
    "",
    "## 8. 未確定事項 [空欄禁止]",
    "",
    "- PENDING: investigation の結論によりスコープ/受入条件を更新する。",
    "",
    "## 9. 関連資料リンク [空欄禁止]",
    "",
    "- request: $requestPathLabel",
    "- investigation: $investigationPathLabel",
    "- plan: $planPathLabel",
    "- review: $reviewPathLabel",
    "- docs:",
    "  - ${backtick}$runbookDoc${backtick}",
    "  - ${backtick}$schemaDoc${backtick}",
    "  - ${backtick}$backlogLabel${backtick}"
  ) -join "`n"

  $planContent = @(
    "# Plan: $taskId",
    "",
    "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
    "",
    "- 参照資料:",
    "  - ${backtick}AGENTS.md${backtick}",
    "  - ${backtick}$docsIndexLabel${backtick}",
    "  - ${backtick}$specPathLabel${backtick}",
    "- 理解ポイント:",
    "  - plan-draft 完了後に depends_on gate を確認し、plan-final を確定してから実装する。",
    "",
    "## 1. 対象仕様",
    "",
    "- $specPathLabel",
    "",
    "## 2. plan-draft",
    "",
    "- 目的:",
    "  - $title",
    "- 実施項目:",
    "  1. investigation を実施し、対象ファイルと変更方針を確定する。",
    "  2. docs 操作（create/update/move/delete）の実施順と rollback を決める。",
    "  3. validator / checker を PASS する手順を確定する。",
    "- 成果物:",
    "  - 実装差分（必要な場合）",
    "  - docs 差分（必要な場合）",
    "",
    "## 3. depends_on gate",
    "",
    "- 依存: $dependencyLabel",
    "- 判定方針: `depends_on` がすべて done のときのみ `plan-ready` とする。",
    "- 判定結果: PENDING（着手時に更新）",
    "",
    "## 4. plan-final",
    "",
    "- 実装順序: PENDING",
    "- 検証順序: PENDING",
    "- ロールバック: PENDING",
    "",
    "## 5. Execution Commands",
    "",
    "- consistency: pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId $taskId -DocQualityMode warning",
    "- state-validate: pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId $taskId -DocQualityMode warning",
    "- docs-index: pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check"
  ) -join "`n"

  $reviewAcLines = New-Object System.Collections.Generic.List[string]
  foreach ($ac in $acList) {
    $reviewAcLines.Add("- $([string]$ac.id): PENDING - $([string]$ac.text)") | Out-Null
  }

  $reviewContent = @(
    "# Review: $taskId",
    "",
    "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
    "",
    "- 参照資料:",
    "  - ${backtick}AGENTS.md${backtick}",
    "  - ${backtick}$docsIndexLabel${backtick}",
    "  - ${backtick}$specPathLabel${backtick}",
    "  - ${backtick}$planPathLabel${backtick}",
    "- 理解ポイント:",
    "  - 受入条件とテスト要件に対して差分の妥当性を検証する。",
    "",
    "## 1. レビュー対象",
    "",
    "- PENDING: 実装差分 / docs 差分",
    "",
    "## 2. 受入条件評価",
    "",
    ($reviewAcLines -join "`n"),
    "",
    "## 3. テスト結果",
    "",
    "### Unit Test",
    "",
    "- 実施内容: PENDING",
    "- 結果: PENDING",
    "",
    "### Integration Test",
    "",
    "- 実施内容: PENDING",
    "- 結果: PENDING",
    "",
    "### Regression Test",
    "",
    "- 実施内容: PENDING",
    "- 結果: PENDING",
    "",
    "### Manual Verification",
    "",
    "- 実施内容: PENDING",
    "- 結果: PENDING",
    "",
    "## 4. 指摘事項",
    "",
    "- 重大: PENDING",
    "- 改善提案: PENDING",
    "",
    "## 5. 結論",
    "",
    "- PENDING"
  ) -join "`n"

  $stateObj = [PSCustomObject]@{
    state = "planned"
    owner = $Owner
    updated_at = $nowIso
    blocking_issues = @()
    depends_on = $dependsOn
  }
  $stateContent = $stateObj | ConvertTo-Json -Depth 8

  $entry = [PSCustomObject]@{
    task_id = $taskId
    title = $title
    priority = $priority
    depends_on = $dependsOn
    work_root = $workRoot
    task_dir = $taskDir
    files = @(
      @{ path = "request.md"; content = $requestContent },
      @{ path = "investigation.md"; content = $investigationContent },
      @{ path = "spec.md"; content = $specContent },
      @{ path = "plan.md"; content = $planContent },
      @{ path = "review.md"; content = $reviewContent },
      @{ path = "state.json"; content = $stateContent }
    )
  }
  $entries.Add($entry) | Out-Null
}

# Stable ordering: P0..P3 then task_id
$priorityOrder = @{ P0 = 0; P1 = 1; P2 = 2; P3 = 3 }
$sortedEntries = @($entries | Sort-Object @{ Expression = { $priorityOrder[$_.priority] } }, @{ Expression = { $_.task_id } })

Write-Output "onboarding-apply: PLAN"
Write-Output "repo_root=$repoRootFull"
Write-Output ("work_root=" + (ConvertTo-NormalizedRepoPath -PathValue (Normalize-RepoRelPath -RepoRootFullPath $repoRootFull -FullPath $workRoot)))
Write-Output ("docs_root=" + (ConvertTo-NormalizedRepoPath -PathValue (Normalize-RepoRelPath -RepoRootFullPath $repoRootFull -FullPath $docsRoot)))
foreach ($e in $sortedEntries) {
  Write-Output ("task_id=" + $e.task_id)
  Write-Output ("  title=" + $e.title)
  Write-Output ("  priority=" + $e.priority)
  Write-Output ("  depends_on=" + ((@($e.depends_on) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join "," ))
  foreach ($f in $e.files) {
    Write-Output ("  write=" + (Join-Path -Path $e.task_dir -ChildPath $f.path))
  }
}

if ($DryRun) {
  Write-Output "onboarding-apply: DRY_RUN"
  exit 0
}

Ensure-Directory -Path $workRoot

foreach ($e in $sortedEntries) {
  Ensure-Directory -Path $e.task_dir
  foreach ($f in $e.files) {
    $path = Join-Path -Path $e.task_dir -ChildPath $f.path
    Set-Content -LiteralPath $path -Value ([string]$f.content)
  }
}

$workRootLabel = ConvertTo-NormalizedRepoPath -PathValue $workflowPaths.task_root
$backlogUpdated = Upsert-Backlog -BacklogPath $backlogPath -Entries $sortedEntries -WorkRootLabel $workRootLabel
Set-Content -LiteralPath $backlogPath -Value $backlogUpdated -NoNewline

$memoryUpdated = Append-MemoryNote -MemoryPath $memoryPath -Entries $sortedEntries
if ($null -ne $memoryUpdated) {
  Set-Content -LiteralPath $memoryPath -Value $memoryUpdated -NoNewline
}

# Keep docs/INDEX.md consistent with filesystem (ops docs are runtime-managed).
$docsIndexerPath = Join-Path -Path $repoRootFull -ChildPath "tools/docs-indexer/index.ps1"
if (Test-Path -LiteralPath $docsIndexerPath -PathType Leaf) {
  Push-Location -LiteralPath $repoRootFull
  try {
    pwsh -NoProfile -File $docsIndexerPath -Mode apply | Out-Null
  } finally {
    Pop-Location
  }
}

Write-Output "onboarding-apply: PASS"
Write-Output ("created_task_count=" + $sortedEntries.Count)
exit 0
