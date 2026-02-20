# Plan: 2026-02-20__add-runtime-installer-with-agentrail-work-layout

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md`
- 理解ポイント:
  - 実装前に depends_on とゲート状態を確認する。

## 1. 対象仕様

- `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: 外部利用時の成果物を .agentrail/work に統一し、導入をスクリプト化する。
- 実施項目:
  1. `tools/runtime/install-runtime.ps1` のパラメータと上書き方針を定義する。
  2. installer で `.agentrail/work` と `workflow.task_root` 更新を実装する。
  3. 一時導入先での dry-run/apply 検証手順を確定する。
- 成果物:
  - `tools/runtime/install-runtime.ps1`
  - `docs/operations/runtime-installation-runbook.md`
  - 更新済み `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md`

## 3. depends_on gate

- 依存: `2026-02-20__define-runtime-manifest-and-export-flow`
- 判定方針: 依存タスクがすべて done になるまで dependency-blocked を維持する。

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. installer を追加し、runtime source から導入先へコピーする処理を実装する。
  2. installer で `.agentrail/work` 作成と `project.profile.yaml` の `workflow.task_root` / `workflow.runtime_root` 調整を実装する。
  3. runbook と task 文書を更新し、検証結果を review/state/backlog に反映する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply`
  2. `pwsh -NoProfile -File tools/runtime/install-runtime.ps1 -TargetRoot .tmp/runtime-install-smoke -DryRun`
  3. `pwsh -NoProfile -File tools/runtime/install-runtime.ps1 -TargetRoot .tmp/runtime-install-smoke`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__add-runtime-installer-with-agentrail-work-layout`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- ロールバック: 対象コミットを単位に戻し、spec と plan を再確認して再実装する

## 5. Execution Commands

- `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply`
- `pwsh -NoProfile -File tools/runtime/install-runtime.ps1 -TargetRoot .tmp/runtime-install-smoke -DryRun`
- `pwsh -NoProfile -File tools/runtime/install-runtime.ps1 -TargetRoot .tmp/runtime-install-smoke`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- 受入条件の判定結果を `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md` に記録する。
- 対象 task の検証コマンドが成功する。

