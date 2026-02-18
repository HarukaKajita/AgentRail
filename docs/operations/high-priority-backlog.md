# 高優先バックログ

## 目的

次に着手すべき高優先タスクを docs から俯瞰できるようにする。

## 優先タスク一覧

1. `2026-02-18__docs-indexer-check-mode`
- 状態: planned
- 目的: `docs-indexer` の `check` モードを導入し、CI 判定を非破壊化
- 参照: `work/2026-02-18__docs-indexer-check-mode/spec.md`

2. `2026-02-18__project-profile-schema-validation`
- 状態: planned
- 目的: `project.profile.yaml` の専用 validator 導入
- 参照: `work/2026-02-18__project-profile-schema-validation/spec.md`

3. `2026-02-18__state-transition-validation`
- 状態: planned
- 目的: `state.json` の整合検証を CI に導入
- 参照: `work/2026-02-18__state-transition-validation/spec.md`

## Completed

1. `2026-02-18__self-improvement-loop-enforcement`
- 状態: done
- 目的: Process Findings + 改善起票強制 + CI 改善ゲート導入
- 参照: `work/2026-02-18__self-improvement-loop-enforcement/spec.md`

## 更新ルール

- task の状態を更新したら本資料も同時更新する。
- 完了タスクは `Completed` セクションへ移動する。
- `review.md` の `Process Findings` で `must/high` が検出された場合は、同一PR内で follow-up task を起票して本資料へ登録する。
- 自動起票時は `tools/improvement-harvest/create-task.ps1` を使用し、`request/spec` に source task と finding ID を記録する。
