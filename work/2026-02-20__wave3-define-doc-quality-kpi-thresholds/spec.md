# 仕様書: 2026-02-20__wave3-define-doc-quality-kpi-thresholds

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/request.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/investigation.md`
- 理解ポイント:
  - Wave 3 の最初の成果物は、後続 automation/loop が共通で参照できる KPI 契約である。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave3-define-doc-quality-kpi-thresholds
- タイトル: Wave 3: docs品質 KPI 閾値定義
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: Wave 2 で docs品質 warning/fail の段階導入は完了したが、改善優先度を判断する KPI 基準が未定義。
- 目的: 更新遅延 / 導線整合 / 網羅率の 3 KPI と暫定閾値を固定し、運用判定を標準化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/operations/wave3-doc-quality-kpi-thresholds.md` の新規作成。
- KPI 算出式、暫定閾値、guardrail、baseline の定義。
- backlog / task state / MEMORY の次タスク同期。

### 3.2 Out of Scope (必須)

- KPI 自動集計スクリプト実装（task11で実施）。
- KPI 悪化時の改善起票自動化（task12で実施）。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `docs/operations/wave3-doc-quality-kpi-thresholds.md` に 3 KPI（KPI-FRESH-01 / KPI-LINK-01 / KPI-COVER-01）と算出式が定義される。
- AC-002: 同ドキュメントに暫定閾値（Green/Yellow/Red）と Guardrail（DQ-001/003/004=0）が明記される。
- AC-003: baseline 観測値（task_count / warning_count / warning_free_ratio / rule別件数）が 2026-02-20 の値で記録される。
- AC-004: backlog / state / MEMORY が `2026-02-20__wave3-automate-doc-quality-metrics-report` 着手状態へ同期される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/*`
- **検証項目**:
  - KPI ID、閾値、baseline 値、関連リンクの記述整合。
- **合格基準**:
  - `rg -n "KPI-FRESH-01|KPI-LINK-01|KPI-COVER-01|Guardrail|warning_free_task_ratio" docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: Wave 2 完了タスクと task10 の連携。
- **検証項目**: depends_on 記述と gate 状態の整合。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates,2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全 task の validator 運用。
- **検証項目**: 既存 PASS を維持する。
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. backlog で task10 が Completed、task11 が plan-ready であることを確認。
  2. MEMORY の現在タスクが task11 に更新されていることを確認。
  3. `docs/INDEX.md` に KPI 閾値ドキュメント導線があることを確認。
- **期待される結果**: AC-001 〜 AC-004 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
  - `MEMORY.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/*`
- 影響する仕様:
  - `docs/operations/human-centric-doc-bank-migration-plan.md`（Wave 3 Stabilization）
- 非機能影響:
  - docs品質改善の優先度判断を定量化できる。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: KPI は既存ツール出力（consistency/state）から算出可能な指標を優先する。
- 想定リスク:
  - 閾値設定が厳しすぎて運用負荷が増える。
  - baseline が欠落し比較不能になる。
- 回避策:
  - baseline を同一文書に固定し、task11 で自動集計化する。

## 8. 未確定事項 (Open Issues) (必須)

- KPI-FRESH-01 の自動算出ロジック詳細（task11で確定）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/request.md`
- investigation: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/investigation.md`
- plan: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/plan.md`
- review: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/review.md`
- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
