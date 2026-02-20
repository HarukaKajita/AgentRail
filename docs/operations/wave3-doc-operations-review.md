# Wave 3: Doc Operations Review

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `work/2026-02-20__run-wave3-doc-operations-review/spec.md`
- 理解ポイント:
  - 本資料は wave3 docs の運用レビュー観点を固定し、改善起票へ接続するための実務 runbook。

## 1. 目的

- wave3 docs 3資料の運用整合（責務/タイミング/改善接続）を定期レビューできる状態を作る。
- レビュー結果を `review.md` の Process Findings と follow-up task 起票へ接続する。

## 2. レビュー対象

- `docs/operations/wave3-doc-quality-kpi-thresholds.md`
- `docs/operations/wave3-doc-quality-metrics-report-automation.md`
- `docs/operations/wave3-kpi-process-findings-loop.md`

## 3. レビュー周期

- 定例:
  - 四半期ごとに 1 回（Q1/Q2/Q3/Q4 の初月第1週）
- 臨時:
  - KPI `overall_status=red` 発生時
  - wave3 運用 docs に大幅改訂（セクション追加/削除）が入った時

## 4. チェックリスト

| 観点 ID | 観点 | 判定質問 | 合格基準 |
| --- | --- | --- | --- |
| OR-001 | 責務の明確性 | 実行者/確認者/代行者が定義されているか | 3資料間で役割が矛盾しない |
| OR-002 | 実行タイミング | 週次/リリース前/臨時のトリガーが明示されているか | 判断に追加解釈が不要 |
| OR-003 | 改善接続 | `yellow/red` 時の Process Findings と起票条件が明示されているか | `action_required` 判定が再現可能 |
| OR-004 | 証跡管理 | レビュー結果と実行証跡の保管先が明示されているか | `review.md`/`backlog`/`MEMORY` の導線がある |
| OR-005 | 記述重複 | 同一ルールが複数資料で矛盾なく記載されているか | 用語と閾値が一致する |

## 5. 2026-02-20 レビュー結果

| 観点 ID | 判定 | 根拠 | 対応 |
| --- | --- | --- | --- |
| OR-001 | PASS | `wave3-kpi-report-execution-calendar` で Execution/Review/Backup を定義し、3資料から参照可能 | 維持 |
| OR-002 | PASS | 週次/リリース前/臨時トリガーが calendar と各 runbook で整合 | 維持 |
| OR-003 | PASS | `overall_status` 別の `action_required` 判定が loop docs に明示 | 維持 |
| OR-004 | PASS | `review.md` / `high-priority-backlog.md` / `MEMORY.md` 同期手順を明記 | 維持 |
| OR-005 | PASS | KPI 閾値・判定表現に重大な矛盾なし | 維持 |

## 6. 改善候補（優先度付き）

| 優先度 | 候補 | 理由 | 起票要否 |
| --- | --- | --- | --- |
| low | 用語統一（`release` / `リリース`） | 表記揺れはあるが運用判断に影響しない | 任意 |
| low | 事例サンプルの拡充 | 初回運用時の理解コストを下げられる | 任意 |

## 7. Process Findings 連携テンプレート

```markdown
### 6.x Finding F-W3OPS-001
- finding_id: F-W3OPS-001
- category: flow
- severity: low
- summary: Wave3 docs operations review completed with checklist OR-001..OR-005.
- evidence: review_doc=docs/operations/wave3-doc-operations-review.md; checklist_pass=5/5
- action_required: no
- linked_task_id: none
```

`must/high` が出た場合のみ `action_required: yes` とし、同一 PR で follow-up task を起票する。

## 8. 関連リンク

- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
- work:
  - `work/2026-02-20__run-wave3-doc-operations-review/spec.md`
