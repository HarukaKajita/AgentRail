# Plan: 2026-02-20__wave3-connect-kpi-to-process-findings-loop

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
- 理解ポイント:
  - task12 は Wave 3 の出口として、KPI 悪化時に改善起票が必ず走る運用を作る。

## 1. 対象仕様

- `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: KPI report と Process Findings / create-task を接続する。
- 実施項目:
  1. loop runbook を追加する。
  2. finding テンプレート生成スクリプトを追加する。
  3. Wave 3 完了状態へ backlog/MEMORY/state を同期する。
- 成果物:
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `tools/doc-quality/generate-finding-template.ps1`
  - task12 成果物6ファイル

## 3. depends_on gate

- 依存: `2026-02-20__wave3-automate-doc-quality-metrics-report`
- 判定方針: task11 が done の場合のみ task12 を確定する。
- 判定結果: pass（task11 done）

## 4. 確定実装計画 (Plan Final)

- 実行フェーズ:
  1. 実装: finding テンプレート生成スクリプト追加
  2. docs: loop runbook 追加と migration plan 導線更新
  3. task: request/investigation/spec/plan/review/state を実績化
  4. 同期: backlog/MEMORY を Wave 3 完了状態へ更新
  5. 検証: unit/integration/regression/manual を実行
- 検証順序:
  1. `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
  2. `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json`
  3. `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json -OutputFormat json`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-automate-doc-quality-metrics-report,2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  7. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  8. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  9. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - template 出力が運用要件に合わない場合は runbook の手動テンプレート運用へ戻し、script を再調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
- `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json`
- `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json -OutputFormat json`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-automate-doc-quality-metrics-report,2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-003 が review で PASS。
- `state.json` は `done`。
- backlog の `優先タスク一覧` が空、Wave 3 実行タスクがすべて Completed へ移動している。
