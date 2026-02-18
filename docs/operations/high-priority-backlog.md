# 高優先バックログ

## 目的

次に着手すべき高優先タスクを docs から俯瞰できるようにする。

## 優先タスク一覧

1. `2026-02-18__framework-request-to-commit-visual-guide`
- 状態: planned
- 目的: 要望提示から実装・コミットまでの流れを図解し、CLI 要望例と AI 応答例を含む運用資料を作成する
- 参照: `work/2026-02-18__framework-request-to-commit-visual-guide/spec.md`

2. `2026-02-18__consistency-check-json-schema-version-policy`
- 状態: planned
- 目的: consistency-check JSON 出力に `schema_version` を追加し、互換方針を定義する
- 参照: `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`

3. `2026-02-18__consistency-check-all-tasks-exclusion-rules`
- 状態: planned
- 目的: `-AllTasks` 実行時の除外条件（archive/legacy）を定義する
- 参照: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`

4. `2026-02-18__validator-enhancement-backlog-reflection`
- 状態: planned
- 目的: profile/state validator の強化項目を構造化して運用バックログへ反映する
- 参照: `work/2026-02-18__validator-enhancement-backlog-reflection/spec.md`

## Completed

1. `2026-02-18__ci-task-resolution-no-fallback`
- 状態: done
- 目的: task-id fallback を廃止し、差分0件時は checker を skip する
- 参照: `work/2026-02-18__ci-task-resolution-no-fallback/spec.md`

2. `2026-02-18__docs-indexer-check-mode`
- 状態: done
- 目的: `docs-indexer` の `check` モードを導入し、CI 判定を非破壊化
- 参照: `work/2026-02-18__docs-indexer-check-mode/spec.md`

3. `2026-02-18__project-profile-schema-validation`
- 状態: done
- 目的: `project.profile.yaml` の専用 validator 導入
- 参照: `work/2026-02-18__project-profile-schema-validation/spec.md`

4. `2026-02-18__state-transition-validation`
- 状態: done
- 目的: `state.json` の整合検証を CI に導入
- 参照: `work/2026-02-18__state-transition-validation/spec.md`

5. `2026-02-18__consistency-check-json-output`
- 状態: done
- 目的: `check_consistency` に JSON 出力を追加し機械可読性を向上する
- 参照: `work/2026-02-18__consistency-check-json-output/spec.md`

6. `2026-02-18__consistency-check-multi-task-mode`
- 状態: done
- 目的: `check_consistency` に複数 task 一括検査モードを追加する
- 参照: `work/2026-02-18__consistency-check-multi-task-mode/spec.md`

7. `2026-02-18__self-improvement-loop-enforcement`
- 状態: done
- 目的: Process Findings + 改善起票強制 + CI 改善ゲート導入
- 参照: `work/2026-02-18__self-improvement-loop-enforcement/spec.md`

## 更新ルール

- task の状態を更新したら本資料も同時更新する。
- 完了タスクは `Completed` セクションへ移動する。
- `review.md` の `Process Findings` で `must/high` が検出された場合は、同一PR内で follow-up task を起票して本資料へ登録する。
- 自動起票時は `tools/improvement-harvest/create-task.ps1` を使用し、`request/spec` に source task と finding ID を記録する。
