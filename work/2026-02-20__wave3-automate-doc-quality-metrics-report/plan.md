# Plan: 2026-02-20__wave3-automate-doc-quality-metrics-report

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
- 理解ポイント:
  - task11 は KPI 定義を再利用し、将来の改善起票ループへ受け渡すレポート schema を固定する。

## 1. 対象仕様

- `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`

## 2. plan-draft

- 目的: KPI 指標を自動算出して JSON/Markdown レポートを生成する。
- 実施項目:
  1. 集計スクリプトを追加する。
  2. 運用 docs を追加する。
  3. backlog/MEMORY/state を task12 着手状態へ同期する。
- 成果物:
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - task11 成果物6ファイル

## 3. depends_on gate

- 依存: `2026-02-20__wave3-define-doc-quality-kpi-thresholds`
- 判定方針: task10 が done の場合のみ task11 を実装する。
- 判定結果: pass（task10 done）

## 4. plan-final

- 実行フェーズ:
  1. script 実装: consistency JSON + state.json から KPI を算出
  2. docs 更新: automation 手順と出力仕様を記録
  3. task 更新: request/investigation/spec/plan/review/state を実績化
  4. 同期: backlog/MEMORY を task12 へ遷移
  5. 検証: unit/integration/regression/manual を実施
- 検証順序:
  1. `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
  2. `pwsh -NoProfile -Command "$json = Get-Content -Raw '.tmp/wave3-metrics-report.json' | ConvertFrom-Json; $json.summary.overall_status; $json.source.warning_count; $json.source.rule_counts.'DQ-002'"`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-define-doc-quality-kpi-thresholds,2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
  5. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  7. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  8. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - 集計スクリプトで不整合が出る場合は task10 baseline 手順に戻し、task11 を `blocked` で再実装する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
- `pwsh -NoProfile -Command "$json = Get-Content -Raw '.tmp/wave3-metrics-report.json' | ConvertFrom-Json; $json.summary.overall_status; $json.source.warning_count; $json.source.rule_counts.'DQ-002'"`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-define-doc-quality-kpi-thresholds,2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-003 が review で PASS。
- `state.json` は `done`。
- backlog と MEMORY の現在タスクが `2026-02-20__wave3-connect-kpi-to-process-findings-loop` へ更新される。
