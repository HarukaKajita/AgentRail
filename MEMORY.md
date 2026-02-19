# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__rail10-skill-command-path-fix
- タイトル: Rail10 Skill Command Path Fix
- 状態: planned
- 最終更新日時: 2026-02-19T22:17:35+09:00
- 担当: codex

## 2. 今回の目的

- Rail10 の SKILL コマンド案内をスキル同梱 script 実行に統一する。
- planned タスクを優先順で1件ずつ完了し、次タスクへ移る前に必ずコミットする。

## 3. 完了済み

- 2026-02-19__task-commit-boundary-automation-flow を完了。
- 2026-02-19__task-dependency-aware-prioritization-flow を完了し、依存優先フローを実装。
- 2026-02-19__task-doc-prerequisite-knowledge-section を完了し、前提知識セクション標準化と checker 連携を反映。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: active task（planned/in_progress/blocked）の equest/investigation/spec/plan/review には 前提知識 セクションを必須化する。
- 決定内容: 	ools/consistency-check/check.ps1 で前提知識セクションの存在と参照解決を検証する。
- 根拠資料:
  - AGENTS.md
  - docs/templates/spec.md
  - docs/templates/investigation.md
  - docs/templates/review.md
  - work/2026-02-19__task-doc-prerequisite-knowledge-section/review.md

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 2026-02-19__rail10-skill-command-path-fix を完了する。
2. その後 2026-02-19__ci-profile-schema-version-governance-gate に着手する。

## 7. 参照先

- work/2026-02-19__task-doc-prerequisite-knowledge-section/request.md
- work/2026-02-19__task-doc-prerequisite-knowledge-section/investigation.md
- work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md
- work/2026-02-19__task-doc-prerequisite-knowledge-section/plan.md
- work/2026-02-19__task-doc-prerequisite-knowledge-section/review.md

## 8. 引き継ぎ時チェック

- [x] state.json が最新か
- [x] docs/INDEX.md を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
