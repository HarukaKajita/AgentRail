# Wave 3: Doc Quality Metrics Report Automation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
- 理解ポイント:
  - KPI は warning モード観測値から定期生成し、改善優先度判断に使う。

## 1. 目的

- task10 で定義した KPI を機械的に算出し、JSON/Markdown レポートを生成する。
- 手動集計を廃止し、Wave 3 の改善ループへ接続しやすくする。

## 2. 実装概要

- スクリプト: `tools/doc-quality/generate-kpi-report.ps1`
- 入力:
  - `tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
  - `work/*/state.json` (`planned/in_progress/blocked` の stale 判定)
- 出力:
  - JSON レポート（デフォルト: `.tmp/doc-quality-kpi-report.json`）
  - Markdown レポート（デフォルト: `.tmp/doc-quality-kpi-report.md`）

## 3. KPI 算出ロジック

1. `KPI-FRESH-01`
   - 指標: `stale_active_task_count_14d`
   - 定義: active task のうち `updated_at` が 14 日超の件数
2. `KPI-LINK-01`
   - 指標: `dq002_warning_count`
   - 定義: `rule_id=DQ-002` の warning 件数
3. `KPI-COVER-01`
   - 指標: `warning_free_task_ratio`
   - 定義: `doc_quality_issue_count=0` task / 全 task

## 4. 実行コマンド

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1
```

出力先を明示する場合:

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 \
  -OutputJsonFile .tmp/wave3-metrics-report.json \
  -OutputMarkdownFile .tmp/wave3-metrics-report.md
```

## 5. 出力仕様（抜粋）

- JSON:
  - `schema_version`
  - `generated_at`
  - `source.task_count`
  - `source.warning_count`
  - `source.warning_free_task_ratio`
  - `source.stale_active_task_count_14d`
  - `kpis[]`
  - `guardrails[]`
  - `summary.overall_status`
- Markdown:
  - KPI テーブル
  - Guardrail テーブル
  - stale task 一覧

## 6. 判定ルール

- `overall_status=red`
  - Guardrail fail が 1 件以上、または red KPI が 1 件以上
- `overall_status=yellow`
  - red がなく yellow KPI が 1 件以上
- `overall_status=green`
  - 上記以外

## 7. 運用手順

1. 週次または release 前にスクリプトを実行する（時刻/責務は `docs/operations/wave3-kpi-report-execution-calendar.md` を参照）。
2. `summary.overall_status` が `yellow/red` の場合は `review.md` に Process Finding を記録する。
3. `linked_task_id` を付与して follow-up task を backlog へ登録する。

## 8. ロールバック

- レポート生成に失敗した場合は、task10 baseline 手順（`consistency-check` JSON）で手動算出に戻す。
- ただし Guardrail 判定（DQ-001/003/004）は維持する。

## 9. 関連リンク

- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
- work:
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
