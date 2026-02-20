# State Validator Done Docs Index Consistency

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

`state=done` の task が docs 更新漏れのまま完了扱いになることを防ぐ。

## 検証ルール

`tools/state-validate/validate.ps1` は `state=done` の task に対して、以下を検証する。

1. `spec.md` の `## 9. 関連資料リンク` に `docs/...` パスがあること
2. 参照された docs パスが実在すること
3. 参照された docs パスが `docs/INDEX.md` に収録されていること

## 実行コマンド

- 全 task 検証: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- 単一 task 検証: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id>`
- カスタム index で検証: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id> -WorkRoot <work-root> -DocsIndexPath <index-path>`

## 運用メモ

- この検証は `state=done` のときのみ適用される。
- docs path の抽出対象は backtick で記述された `docs/...` リンク。
- `docs/INDEX.md` の同期は `tools/docs-indexer/index.ps1` を正とする。

## 関連資料リンク

- docs:
  - `docs/operations/state-history-strategy.md`
  - `docs/operations/high-priority-backlog.md`
- work:
  - `work/2026-02-19__state-validator-done-docs-index-consistency/spec.md`
  - `work/2026-02-19__state-validator-done-docs-index-consistency/review.md`
