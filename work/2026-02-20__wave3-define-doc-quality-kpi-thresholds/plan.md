# Plan: 2026-02-20__wave3-define-doc-quality-kpi-thresholds

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
- 理解ポイント:
  - task10 は Wave 3 2段階目（automation）の入力仕様を先に固定する役割を持つ。

## 1. 対象仕様

- `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: docs品質KPIの算出式と暫定閾値を定義する。
- 実施項目:
  1. baseline 観測値を取得して記録する。
  2. KPI 3指標と閾値・guardrail を文書化する。
  3. backlog / MEMORY / state を次タスク着手状態へ同期する。
- 成果物:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - task10 の request/investigation/spec/plan/review/state
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
  - `MEMORY.md`

## 3. depends_on gate

- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`, `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`
- 判定方針: 依存タスクが `done` の場合のみ本タスクを `done` 化する。
- 判定結果: pass（両タスクとも done）

## 4. 確定実装計画 (Plan Final)

- 実行フェーズ:
  1. baseline 取得: all tasks warning JSON を取得して基準値を記録
  2. docs 更新: KPI 定義文書と INDEX 導線を追加
  3. task 更新: request/investigation/spec/plan/review/state を実績化
  4. 同期: backlog/MEMORY を task11 着手状態へ更新
  5. 検証: consistency/state/docs-indexer を実行
- 検証順序:
  1. `rg -n "KPI-FRESH-01|KPI-LINK-01|KPI-COVER-01|Guardrail|warning_free_task_ratio" docs/operations/wave3-doc-quality-kpi-thresholds.md`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates,2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
  5. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  7. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - 閾値定義が不適切な場合は `state=blocked` へ戻し、KPI-LINK-01 の閾値を baseline ベースへ再設定する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json -OutputFile .tmp/wave3-doc-quality-baseline.json`
- `rg -n "KPI-FRESH-01|KPI-LINK-01|KPI-COVER-01|Guardrail|warning_free_task_ratio" docs/operations/wave3-doc-quality-kpi-thresholds.md`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates,2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-define-doc-quality-kpi-thresholds -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-004 が review で PASS。
- `state.json` は `done`。
- backlog と MEMORY の現在タスクが `2026-02-20__wave3-automate-doc-quality-metrics-report` へ遷移している。
