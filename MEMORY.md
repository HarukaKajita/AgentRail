# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__ci-profile-schema-version-governance-gate
- タイトル: CI Profile Schema Version Governance Gate
- 状態: planned
- 最終更新日時: 2026-02-19T23:09:18+09:00
- 担当: codex

## 2. 今回の目的

- `project.profile.yaml` schema の変更時に `schema_version` 運用を CI で強制する。
- planned タスクを優先順で1件ずつ完了し、次タスクへ移る前に必ずコミットする。

## 3. 完了済み

- `2026-02-19__task-commit-boundary-automation-flow` を完了。
- `2026-02-19__task-dependency-aware-prioritization-flow` を完了。
- `2026-02-19__task-doc-prerequisite-knowledge-section` を完了。
- `2026-02-19__rail10-skill-command-path-fix` を完了。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: Rail10 のコマンド案内は `$HOME/.agents` を使わず、スキル同梱 `scripts/list_planned_tasks.ps1` 実行で統一する。
- 決定内容: active task では `前提知識` セクションを checker で必須化する。
- 根拠資料:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/review.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-19__ci-profile-schema-version-governance-gate` を完了する。
2. CI governance step と docs 運用の整合を最終確認してコミットする。

## 7. 参照先

- `work/2026-02-19__rail10-skill-command-path-fix/request.md`
- `work/2026-02-19__rail10-skill-command-path-fix/investigation.md`
- `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
- `work/2026-02-19__rail10-skill-command-path-fix/plan.md`
- `work/2026-02-19__rail10-skill-command-path-fix/review.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
