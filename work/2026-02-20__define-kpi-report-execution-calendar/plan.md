# Plan: 2026-02-20__define-kpi-report-execution-calendar

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`
- 理解ポイント:
  - depends_on は解決済みのため、本タスクでは plan-final を確定して運用 docs を反映する。

## 1. 対象仕様

- `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`

## 2. plan-draft

- 目的:
  - KPI レポート実行タイミングを運用カレンダーとして確定する。
- 実施項目:
  1. 週次/リリース前/臨時の実行条件を定義する。
  2. 実行担当、レビュー反映先、エスカレーションを定義する。
  3. 既存 wave3 docs からの参照導線を計画する。
- 成果物:
  - KPI 実行カレンダー定義
  - wave3 docs 導線更新案

## 3. depends_on gate

- 依存: `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
- 判定方針: 依存 task が done なら `plan-ready`。
- 判定結果: pass（依存解決済み）

## 4. plan-final

- 実装順序:
  1. `docs/operations/wave3-kpi-report-execution-calendar.md` を新規作成し、週次/リリース前/臨時の実行契約を定義する。
  2. `wave3-doc-quality-kpi-thresholds` / `wave3-doc-quality-metrics-report-automation` / `wave3-kpi-process-findings-loop` に運用カレンダー導線を追加する。
  3. task3 の調査・仕様・計画・レビュー・状態ファイルを実績化し、backlog/MEMORY を次タスク着手状態へ更新する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- ロールバック:
  - 実行タイミングが過密な場合は時刻のみ調整し、週次/リリース前/臨時の3区分は維持する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001 と AC-002 が review で PASS。
- `state.json` は `done`。
- backlog の次着手候補が `2026-02-20__run-wave3-doc-operations-review` のみになる。
