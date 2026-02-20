# Wave 3: Doc Quality KPI Thresholds

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
- 理解ポイント:
  - Wave 3 では docs品質ゲートを「運用KPI」として継続監視できる形に定義する。

## 1. 目的

- docs品質の改善を「感覚」ではなく「定量指標」で運用判断できる状態にする。
- Wave 2 の warning/fail 運用を壊さず、Wave 3 の自動集計と改善ループへ接続する。

## 2. KPI 一覧（暫定）

| KPI ID | 観点 | 指標 | 算出式 | データソース |
| --- | --- | --- | --- | --- |
| KPI-FRESH-01 | 更新遅延 | stale_active_task_count_14d | `planned/in_progress/blocked` task のうち `updated_at` が 14 日超の件数 | `work/*/state.json` |
| KPI-LINK-01 | 導線整合 | dq002_warning_count | `DocQualityMode warning` 実行時の `rule_id=DQ-002` 件数 | `tools/consistency-check/check.ps1 -AllTasks -OutputFormat json` |
| KPI-COVER-01 | 網羅率 | warning_free_task_ratio | `doc_quality_issue_count=0` task 数 / `task_count` | `tools/consistency-check/check.ps1 -AllTasks -OutputFormat json` |

## 3. 暫定閾値（2026-02-20 版）

### 3.1 KPI-FRESH-01

- Green: `0`
- Yellow: `1-2`
- Red: `3` 以上

### 3.2 KPI-LINK-01

- Green: `0-21`（現状維持 or 改善）
- Yellow: `22-25`（軽微な悪化）
- Red: `26` 以上（要是正）

### 3.3 KPI-COVER-01

- Green: `>= 60%`
- Yellow: `>= 50% and < 60%`
- Red: `< 50%`

## 4. Guardrail（回帰防止）

- GR-001: `DQ-001` は常に `0`（前提知識欠落を許容しない）
- GR-002: `DQ-003` は常に `0`（docs/INDEX 導線不整合を許容しない）
- GR-003: `DQ-004` は常に `0`（depends_on 不整合を許容しない）

## 5. Baseline Snapshot（2026-02-20）

- 実行コマンド:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json -OutputFile .tmp/wave3-doc-quality-baseline.json`
- 観測値:
  - `task_count=56`
  - `dq002_warning_count=21`
  - `warning_free_task_ratio=62.5%`（35 / 56）
  - `DQ-001=0, DQ-003=0, DQ-004=0`
- 判定:
  - KPI-FRESH-01: 測定は Wave 3 自動集計で開始
  - KPI-LINK-01: Green
  - KPI-COVER-01: Green

## 6. 運用ルール

1. 週次で KPI を更新し、最新値をレポートへ記録する。
2. Red が 1 つでも発生した場合は、`review.md` の Process Findings で `action_required=yes` を設定して follow-up task を起票する。
3. 2 週連続で Yellow が継続した場合は、閾値見直しではなく原因修正を優先する。
4. 実行タイミングと担当は `docs/operations/wave3-kpi-report-execution-calendar.md` の契約に従う。
5. 運用レビューは `docs/operations/wave3-doc-operations-review.md` のチェックリストで四半期ごとに実施する。

## 7. 後続タスクへの引き継ぎ

- `2026-02-20__wave3-automate-doc-quality-metrics-report`
  - KPI 算出を自動化し、JSON/Markdown レポートを出力する。
- `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
  - KPI 悪化時に Process Findings と改善起票を連動させる。

## 8. ロールバック方針

- 閾値が厳しすぎて運用不能な場合は、KPI-LINK-01 を baseline+5 まで一時緩和し、Wave 3 task で再評価する。
- ただし Guardrail（`DQ-001=0`, `DQ-003=0`, `DQ-004=0`）は緩和しない。

## 9. 関連リンク

- docs:
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave3-doc-operations-review.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
- work:
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
