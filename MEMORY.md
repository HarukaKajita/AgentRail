# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__task-doc-prerequisite-knowledge-section
- タイトル: Task/Spec Prerequisite Knowledge Section Standardization
- 状態: planned
- 最終更新日時: 2026-02-19T22:08:32+09:00
- 担当: codex

## 2. 今回の目的

- 仕様資料と task 資料へ前提知識セクションを標準化し、どの資料からでも遡及理解できる導線を作る。
- planned タスクを優先順で1件ずつ完了し、次タスクへ移る前に必ずコミットする。

## 3. 完了済み

- 2026-02-19__task-commit-boundary-automation-flow を完了し、境界コミット運用を標準化した。
- 2026-02-19__task-dependency-aware-prioritization-flow を完了し、depends_on を validator/checker/Rail10/backlog/create-task に統合した。
- 全 task の state.json に depends_on フィールドを追加し、依存整合チェックを有効化した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: depends_on を state.json の必須キーにする。
- 決定内容: 着手ゲートは「state=in_progress|done なら依存先はすべて state=done 必須」とする。
- 決定内容: Rail10 は docs 優先順に加えて依存解決済み優先で着手候補を提示する。
- 根拠資料:
  - AGENTS.md
  - docs/operations/high-priority-backlog.md
  - docs/operations/skills-framework-flow-guide.md
  - work/2026-02-19__task-dependency-aware-prioritization-flow/review.md

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 2026-02-19__task-doc-prerequisite-knowledge-section を実装完了まで進める。
2. タスク完了時に review/docs/memory/state を更新してコミットする。
3. 次順位 2026-02-19__rail10-skill-command-path-fix へ移る。

## 7. 参照先

- work/2026-02-19__task-dependency-aware-prioritization-flow/request.md
- work/2026-02-19__task-dependency-aware-prioritization-flow/investigation.md
- work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md
- work/2026-02-19__task-dependency-aware-prioritization-flow/plan.md
- work/2026-02-19__task-dependency-aware-prioritization-flow/review.md

## 8. 引き継ぎ時チェック

- [x] state.json が最新か
- [x] docs/INDEX.md を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
