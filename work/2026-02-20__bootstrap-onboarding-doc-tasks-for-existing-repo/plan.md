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
  - 起票段階のため未確定。実装着手時に詳細化する。
- 検証順序:
  - 起票段階のため未確定。実装着手時に詳細化する。
- ロールバック:
  - `tools/onboarding/*` と運用 docs を取り下げ、仕様（提案 JSON スキーマ）を見直す。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- 起票境界: request/investigation/spec/plan-draft/backlog/MEMORY の整合が取れている。
- 実装境界: 収集/適用スクリプトと運用 docs が揃い、スモーク検証で PASS する。
