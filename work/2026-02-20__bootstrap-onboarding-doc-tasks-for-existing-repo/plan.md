# Plan: 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/spec.md`
- 理解ポイント:
  - 「高度な情報整理」は高性能モデルに寄せるが、スクリプトは決定を持たず（収集/適用の再現性）を優先する。

## 1. 対象仕様

- `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/spec.md`

## 2. plan-draft

- 目的:
  - 既存リポジトリ導入直後に、資料作成・整備のタスク化へ安全に接続できるブートストラップ機能を追加する。
- 実施項目:
  1. tools/onboarding/collect-existing-repo-context.ps1 を追加し、導入先リポジトリの context を artifacts/onboarding/* へ出力する。
  2. 高性能モデルが出力した artifacts/onboarding/task-proposals.json を入力として、tools/onboarding/apply-task-proposals.ps1 で work/backlog/MEMORY を生成できるようにする。
  3. 収集 -> 提案 -> 適用の運用手順（モデル選定の推奨含む）を docs に追加する。
- 成果物:
  - `tools/onboarding/*`（新規）
  - 運用 docs（新規）
  - スモーク検証（dry-run/apply + checker PASS）

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`
- 判定結果: pass（起票時点）

## 4. plan-final

- 実装順序:
  1. `tools/onboarding/collect-existing-repo-context.ps1` を新規追加する。
  2. `tools/onboarding/apply-task-proposals.ps1` を新規追加する（Pattern B を解釈し、work/backlog/MEMORY を生成）。
  3. 運用資料 `docs/operations/onboarding-existing-repo-document-inventory-runbook.md` を新規追加する。
  4. runtime 配布へ含めるため `framework.runtime.manifest.yaml` を更新する（docs + tools）。
  5. 導入直後に `docs/INDEX.md` 参照整合が取れるよう、seed の `runtime/seed/docs/INDEX.md` を更新する。
  6. `tools/docs-indexer/index.ps1 -Mode apply` を実行し、`docs/INDEX.md` の導線を整合させる。
- 検証順序:
  1. `tools/onboarding/collect-existing-repo-context.ps1` をローカルの本リポジトリ（`D:\dev\AgentRail`）に対して `-DryRun` / 通常実行し、artifacts/onboarding/* が生成されることを確認する。
  2. 最小の artifacts/onboarding/task-proposals.json（Pattern B / task_id 固定）を用意し、`tools/onboarding/apply-task-proposals.ps1` の `-DryRun` が PLAN を出力することを確認する。
  3. `tools/onboarding/apply-task-proposals.ps1` を実行し、生成されたタスクが `consistency-check` / `state-validate` を PASS できることを確認する。
  4. 回帰として `docs-indexer` / `consistency-check -AllTasks` を PASS させる。
- ロールバック:
  - `tools/onboarding/*`、運用 docs、runtime seed/manifest 更新を取り下げる（導入先に不要な機能が混入するため）。
  - そのうえで `docs/operations/onboarding-task-proposals-json-format.md`（入力SSOT）を見直す。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- 起票境界: request/investigation/spec/plan-draft/backlog/MEMORY の整合が取れている。
- 実装境界: 収集/適用スクリプトと運用 docs が揃い、スモーク検証で PASS する。
