# Validator Enhancement Backlog

## 目的

validator（profile/state）の改善候補を、task review から継続的に管理するための運用バックログ。

## 更新ルール

1. validator 関連 task の `review.md` で改善提案または Process Finding が出たら本資料へ追記する。
2. `priority` が `high` 以上、または `status=ready` になった項目は `work/<task-id>/` を起票する。
3. 起票後は `linked_task` に task ID を記録し、完了時に `status=done` へ更新する。

## Backlog Items

| item_id | area | source | proposal | priority | status | linked_task |
| --- | --- | --- | --- | --- | --- | --- |
| VE-001 | profile-validator | `work/2026-02-18__project-profile-schema-validation/review.md` | `requiredChecks` の静的配列管理を見直し、schema 定義との二重管理リスクを下げる。 | medium | proposed | none |
| VE-002 | profile-validator | `work/2026-02-18__project-profile-schema-validation/review.md` | `project.profile.yaml` に `schema_version` フィールドを導入し、validator 互換方針を明確化する。 | low | proposed | none |
| VE-003 | state-validator | `work/2026-02-18__state-transition-validation/review.md` | `done` 判定の検証対象に docs 反映整合（例: `docs/INDEX.md` 導線）を追加する是非を検討する。 | medium | proposed | none |
| VE-004 | state-validator | `work/2026-02-18__state-transition-validation/review.md` | `state history` 管理方式（履歴保持するか、履歴を別 artifacts に逃がすか）を決定する。 | low | proposed | none |

## 関連資料

- `docs/operations/high-priority-backlog.md`
- `docs/specs/phase2-automation-spec.md`
- `tools/profile-validate/validate.ps1`
- `tools/state-validate/validate.ps1`
