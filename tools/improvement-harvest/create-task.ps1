param(
  [Parameter(Mandatory = $true)]
  [string]$SourceTaskId,
  [Parameter(Mandatory = $true)]
  [string]$FindingId,
  [Parameter(Mandatory = $true)]
  [string]$Title,
  [Parameter(Mandatory = $true)]
  [ValidateSet("must", "high", "medium", "low")]
  [string]$Severity,
  [Parameter(Mandatory = $true)]
  [ValidateSet("flow", "docs", "ci", "quality", "other")]
  [string]$Category,
  [string[]]$DependsOn = @(),
  [string]$TaskId = "",
  [string]$WorkRoot = "work",
  [string]$Author = "codex"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail {
  param([string]$Message)
  Write-Error "improvement-create-task: $Message"
  exit 1
}

function Convert-ToSlug {
  param([string]$Value)

  $lower = $Value.ToLowerInvariant()
  $slug = [Regex]::Replace($lower, "[^a-z0-9]+", "-")
  $slug = $slug.Trim('-')
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return "improvement-task"
  }

  return $slug
}

function Get-NextTaskId {
  param(
    [string]$Root,
    [string]$BaseTaskId
  )

  $candidate = $BaseTaskId
  $suffix = 1
  while (Test-Path -LiteralPath (Join-Path -Path $Root -ChildPath $candidate)) {
    $candidate = "{0}-{1:d2}" -f $BaseTaskId, $suffix
    $suffix++
  }

  return $candidate
}

function Resolve-DependencyTaskIds {
  param(
    [string[]]$RawDependencyValues
  )

  $resolved = New-Object System.Collections.Generic.List[string]
  foreach ($rawValue in $RawDependencyValues) {
    foreach ($splitValue in ([string]$rawValue -split ",")) {
      $taskId = $splitValue.Trim()
      if ([string]::IsNullOrWhiteSpace($taskId)) {
        continue
      }
      if ($resolved.Contains($taskId)) {
        continue
      }
      $resolved.Add($taskId) | Out-Null
    }
  }

  return $resolved.ToArray()
}

if (-not (Test-Path -LiteralPath $WorkRoot -PathType Container)) {
  Fail("work root does not exist: $WorkRoot")
}

$sourceTaskPath = Join-Path -Path $WorkRoot -ChildPath $SourceTaskId
if (-not (Test-Path -LiteralPath $sourceTaskPath -PathType Container)) {
  Fail("source task does not exist: $sourceTaskPath")
}

$resolvedTaskId = $TaskId.Trim()
if ([string]::IsNullOrWhiteSpace($resolvedTaskId)) {
  $datePrefix = Get-Date -Format "yyyy-MM-dd"
  $slug = Convert-ToSlug -Value $Title
  $baseTaskId = "${datePrefix}__${slug}"
  $resolvedTaskId = Get-NextTaskId -Root $WorkRoot -BaseTaskId $baseTaskId
}

$dependencyTaskIds = @(Resolve-DependencyTaskIds -RawDependencyValues $DependsOn)
foreach ($dependencyTaskId in $dependencyTaskIds) {
  if ($dependencyTaskId -eq $resolvedTaskId) {
    Fail("depends_on must not include the created task itself: $dependencyTaskId")
  }

  $dependencyTaskPath = Join-Path -Path $WorkRoot -ChildPath $dependencyTaskId
  if (-not (Test-Path -LiteralPath $dependencyTaskPath -PathType Container)) {
    Fail("depends_on references missing task directory: $dependencyTaskPath")
  }
}

$newTaskPath = Join-Path -Path $WorkRoot -ChildPath $resolvedTaskId
if (Test-Path -LiteralPath $newTaskPath) {
  Fail("task already exists: $newTaskPath")
}

$today = Get-Date -Format "yyyy-MM-dd"
$nowIso = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"
$seedActionRequired = if ($Severity -in @("must", "high")) { "yes" } else { "no" }
$seedLinkedTaskId = if ($seedActionRequired -eq "yes") { $resolvedTaskId } else { "none" }
$backtick = [string][char]96
$dependencyLabel = if ($dependencyTaskIds.Count -eq 0) {
  "なし"
} else {
  ($dependencyTaskIds | ForEach-Object { "$backtick$_$backtick" }) -join ", "
}

New-Item -ItemType Directory -Path $newTaskPath -Force | Out-Null

$requestContent = @(
  "# Request: $resolvedTaskId",
  "",
  "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
  "",
  "- 参照資料:",
  "  - ${backtick}AGENTS.md${backtick}",
  "  - ${backtick}docs/INDEX.md${backtick}",
  "  - ${backtick}work/$SourceTaskId/review.md${backtick}",
  "- 理解ポイント:",
  "  - source task の finding 文脈と依存関係を把握してから着手する。",
  "",
  "## 要望の原文",
  "",
  "- Process finding から自己改善タスクを自動起票する。",
  "",
  "## 要望の整理",
  "",
  "- Source Task: $SourceTaskId",
  "- Finding ID: $FindingId",
  "- Category: $Category",
  "- Severity: $Severity",
  "- Title: $Title",
  "- Depends On: $dependencyLabel",
  "",
  "## 成功条件（要望レベル）",
  "",
  "1. work/$resolvedTaskId/ に必須6ファイルが作成される。",
  "2. 生成された spec.md が consistency-check の必須フォーマットを満たす。",
  "3. 元タスクと finding のトレーサビリティが残る。",
  "4. state.json に depends_on が定義される。"
) -join "`n"

$investigationContent = @(
  "# Investigation: $resolvedTaskId",
  "",
  "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
  "",
  "- 参照資料:",
  "  - ${backtick}AGENTS.md${backtick}",
  "  - ${backtick}docs/INDEX.md${backtick}",
  "  - ${backtick}work/$SourceTaskId/review.md${backtick}",
  "- 理解ポイント:",
  "  - source finding の再現条件と影響範囲を先に確認する。",
  "",
  "## 1. 調査対象 [空欄禁止]",
  "",
  "- Source task $SourceTaskId の finding $FindingId の根本原因分析。",
  "- 依存タスク (`$depends_on`) の妥当性確認。",
  "",
  "## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]",
  "",
  "- 該当 finding に対する対策を実装すれば、同種の問題を再発防止できる。",
  "",
  "## 3. 観測方法 [空欄禁止]",
  "",
  "- 参照資料:",
  "  - work/$SourceTaskId/review.md",
  "- 実施した確認:",
  "  - finding の再現条件と影響範囲を確認する。",
  "  - depends_on に設定した task-id が着手前完了条件を満たすか確認する。",
  "",
  "## 4. 観測結果 (Observations / 観測結果) [空欄禁止]",
  "",
  "- 調査前。実装時に更新する。",
  "",
  "## 5. 結論 (Conclusion / 結論) [空欄禁止]",
  "",
  "- 調査前。実装時に更新する。",
  "",
  "## 6. 未解決事項 [空欄禁止]",
  "",
  "- 具体的な実装方式の最終選定。",
  "",
  "## 7. 次アクション [空欄禁止]",
  "",
  "1. 要件を確定する。",
  "2. 実装計画を策定する。",
  "",
  "## 8. 関連リンク [空欄禁止]",
  "",
  "- request: work/$resolvedTaskId/request.md",
  "- spec: work/$resolvedTaskId/spec.md"
) -join "`n"

$specContent = @(
  "# 仕様書: $resolvedTaskId",
  "",
  "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
  "",
  "- 参照資料:",
  "  - ${backtick}AGENTS.md${backtick}",
  "  - ${backtick}docs/INDEX.md${backtick}",
  "  - ${backtick}work/$resolvedTaskId/request.md${backtick}",
  "  - ${backtick}work/$resolvedTaskId/investigation.md${backtick}",
  "- 理解ポイント:",
  "  - 要望、調査結果、依存タスクを踏まえて受入条件を定義する。",
  "",
  "## 1. メタ情報 [空欄禁止]",
  "",
  "- Task ID: $resolvedTaskId",
  "- タイトル: $Title",
  "- 作成日: $today",
  "- 更新日: $today",
  "- 作成者: $Author",
  "- 関連要望: work/$resolvedTaskId/request.md",
  "- 依存タスク: $dependencyLabel",
  "",
  "## 2. 背景と目的 [空欄禁止]",
  "",
  "- 背景: $SourceTaskId の finding $FindingId が改善アクションを要求している。",
  "- 目的: finding に対する恒久対応を実装し、同種問題の再発を防止する。",
  "",
  "## 3. スコープ [空欄禁止]",
  "",
  "### 3.1 In Scope [空欄禁止]",
  "",
  "- finding に直接対応する修正を実装する。",
  "- 必要な docs と運用ルールを更新する。",
  "",
  "### 3.2 Out of Scope [空欄禁止]",
  "",
  "- finding と無関係な大規模リファクタ。",
  "",
  "## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]",
  "",
  "- AC-001: finding の原因に対する実装が完了する。",
  "- AC-002: 必要な docs が更新される。",
  "",
  "## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]",
  "",
  "### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]",
  "",
  "- 対象: 修正対象モジュール",
  "- 観点: finding の再発条件が検知/防止される",
  "- 合格条件: 期待どおり PASS",
  "",
  "### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]",
  "",
  "- 対象: CI および関連スクリプト",
  "- 観点: 修正結果がパイプラインへ反映される",
  "- 合格条件: 期待どおり PASS",
  "",
  "### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]",
  "",
  "- 対象: 既存フロー",
  "- 観点: 既存の正常ケースを壊さない",
  "- 合格条件: 期待どおり PASS",
  "",
  "### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]",
  "",
  "- 手順: 対応実装後に対象コマンドを順次実行する",
  "- 期待結果: AC-001 と AC-002 を満たす",
  "",
  "## 6. 影響範囲 [空欄禁止]",
  "",
  "- 影響ファイル/モジュール: finding に関連するファイル一式",
  "- 影響する仕様: 必要に応じて該当 spec を更新",
  "- 非機能影響: 品質と再現性の向上",
  "",
  "## 7. 制約とリスク [空欄禁止]",
  "",
  "- 制約: 既存ワークフロー互換を維持する",
  "- 想定リスク: 修正漏れが残る可能性",
  "- 回避策: reviewer で finding クローズ条件を確認する",
  "",
  "## 8. 未確定事項 [空欄禁止]",
  "",
  "- 実装時に発見された追加要件の扱い。",
  "",
  "## 9. 関連資料リンク [空欄禁止]",
  "",
  "- request: work/$resolvedTaskId/request.md",
  "- investigation: work/$resolvedTaskId/investigation.md",
  "- plan: work/$resolvedTaskId/plan.md",
  "- review: work/$resolvedTaskId/review.md",
  "- docs:",
  "  - docs/operations/high-priority-backlog.md"
) -join "`n"

$planContent = @(
  "# Plan: $resolvedTaskId",
  "",
  "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
  "",
  "- 参照資料:",
  "  - ${backtick}AGENTS.md${backtick}",
  "  - ${backtick}docs/INDEX.md${backtick}",
  "  - ${backtick}work/$resolvedTaskId/spec.md${backtick}",
  "- 理解ポイント:",
  "  - spec の受入条件とテスト要件を基準に実装順序を決定する。",
  "",
  "## 1. 対象仕様",
  "",
  "- work/$resolvedTaskId/spec.md",
  "",
  "## 2. Execution Commands",
  "",
  "- consistency: pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId $resolvedTaskId",
  "- index update: pwsh -NoProfile -File tools/docs-indexer/index.ps1",
  "",
  "## 3. 実施ステップ",
  "",
  "1. finding の再現条件を確認する。",
  "2. depends_on の先行完了状態を確認する。",
  "3. 対応実装を行う。",
  "4. docs と review を更新する。",
  "5. consistency-check を実行する。",
  "",
  "## 4. 変更対象ファイル",
  "",
  "- 実装時に確定",
  "",
  "## 5. リスクとロールバック",
  "",
  "- リスク: finding の再現条件を取り違える",
  "- ロールバック: 直前コミットへ戻し、要件を再確認する",
  "",
  "## 6. 完了判定",
  "",
  "- AC-001 と AC-002 が PASS",
  "- spec.md と review.md が最新化されている"
) -join "`n"

$reviewContent = @(
  "# Review: $resolvedTaskId",
  "",
  "## 前提知識 (Prerequisites / 前提知識) [空欄禁止]",
  "",
  "- 参照資料:",
  "  - ${backtick}AGENTS.md${backtick}",
  "  - ${backtick}docs/INDEX.md${backtick}",
  "  - ${backtick}work/$resolvedTaskId/spec.md${backtick}",
  "  - ${backtick}work/$resolvedTaskId/plan.md${backtick}",
  "- 理解ポイント:",
  "  - 受入条件とテスト要件に対して差分の妥当性を検証する。",
  "",
  "## 1. レビュー対象",
  "",
  "- 対応実装差分一式",
  "",
  "## 2. 受入条件評価",
  "",
  "- AC-001: PENDING",
  "- AC-002: PENDING",
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
  "- 重大: なし",
  "- 改善提案:",
  "  - なし",
  "",
  "## 5. 結論",
  "",
  "- 実装後に最終判定する。",
  "",
  "## 6. Process Findings",
  "",
  "### 6.1 Finding F-001",
  "",
  "- finding_id: F-001",
  "- category: $Category",
  "- severity: $Severity",
  "- summary: Improvement task bootstrap generated from source finding.",
  "- evidence: Source task $SourceTaskId / finding $FindingId requested follow-up.",
  "- action_required: $seedActionRequired",
  "- linked_task_id: $seedLinkedTaskId",
  "",
  "## 7. Commit Boundaries",
  "",
  "### 7.1 Kickoff Commit",
  "",
  "- commit: PENDING",
  "- scope_check: PENDING",
  "",
  "### 7.2 Implementation Commit",
  "",
  "- commit: PENDING",
  "- scope_check: PENDING",
  "",
  "### 7.3 Finalize Commit",
  "",
  "- commit: PENDING",
  "- scope_check: PENDING"
) -join "`n"

$stateObject = [PSCustomObject]@{
  state           = "planned"
  owner           = "unassigned"
  updated_at      = $nowIso
  blocking_issues = @()
  depends_on      = $dependencyTaskIds
}
$stateContent = $stateObject | ConvertTo-Json -Depth 4

Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "request.md") -Value $requestContent
Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "investigation.md") -Value $investigationContent
Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "spec.md") -Value $specContent
Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "plan.md") -Value $planContent
Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "review.md") -Value $reviewContent
Set-Content -LiteralPath (Join-Path -Path $newTaskPath -ChildPath "state.json") -Value $stateContent

Write-Output "improvement-create-task: PASS"
Write-Output "created_task_id=$resolvedTaskId"
Write-Output "created_path=$newTaskPath"
if ($dependencyTaskIds.Count -eq 0) {
  Write-Output "created_depends_on=none"
} else {
  Write-Output ("created_depends_on=" + ($dependencyTaskIds -join ","))
}
exit 0
