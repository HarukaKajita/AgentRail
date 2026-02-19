# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: none
- タイトル: existing docs prerequisites retrofit completed
- 状態: done
- 最終更新日時: 2026-02-20T00:40:03+09:00
- 担当: codex

## 2. 今回の目的

- `project.profile.yaml` schema の変更時に `schema_version` 運用を CI で強制する。
- planned タスクを優先順で1件ずつ完了し、次タスクへ移る前に必ずコミットする。
- 既存資料への前提知識セクション遡及適用（docs/work, archive/legacy 除外）を完了する。

## 3. 完了済み

- `2026-02-19__existing-docs-prerequisites-retrofit` を完了。
- `2026-02-19__ci-profile-schema-version-governance-gate` を完了。
- `2026-02-19__task-commit-boundary-automation-flow` を完了。
- `2026-02-19__task-dependency-aware-prioritization-flow` を完了。
- `2026-02-19__task-doc-prerequisite-knowledge-section` を完了。
- `2026-02-19__rail10-skill-command-path-fix` を完了。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: Rail10 のコマンド案内は `$HOME/.agents` を使わず、スキル同梱 `scripts/list_planned_tasks.ps1` 実行で統一する。
- 決定内容: active task では `前提知識` セクションを checker で必須化する。
- 決定内容: profile schema 変更時は `tools/profile-validate/check-schema-governance.ps1` を CI fail-fast gate として必須実行する。
- 決定内容: 既存資料への前提知識セクション遡及適用は P1-P3 の優先度フェーズで実施する。
- 決定内容: docs 30/30、work 130/130（archive/legacy 除外）で前提知識セクション適用を完了した。
- 根拠資料:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/review.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/review.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 新規要望の受領待ち（`docs/operations/high-priority-backlog.md` の planned は現在 `なし`）。
2. 次回着手時は `docs/operations/high-priority-backlog.md` と `work/*/state.json` の同期を再確認する。

## 7. 参照先

- `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
- `work/2026-02-19__existing-docs-prerequisites-retrofit/investigation.md`
- `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`
- `work/2026-02-19__existing-docs-prerequisites-retrofit/plan.md`
- `work/2026-02-19__existing-docs-prerequisites-retrofit/review.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
