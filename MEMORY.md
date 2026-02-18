# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__framework-request-to-commit-visual-guide
- タイトル: ユーザー要望から実装・コミットまでのフロー可視化資料作成
- 状態: planned
- 最終更新日時: 2026-02-19T00:24:26+09:00
- 担当: Codex

## 2. 今回の目的

- 要望提示から実装・コミットまでのフレームワーク内イベントを図解した資料を作るタスクを起票する。
- CLI 要望サンプルと AI 応答サンプルを含む資料の実装要件を定義する。
- 新規タスクを高優先バックログの最上位に登録する。

## 3. 完了済み

- `work/2026-02-18__framework-request-to-commit-visual-guide/` を起票し、必須6ファイルを生成した。
- 新規タスクの `request/spec/plan/investigation` を可視化資料要件向けに具体化した。
- `docs/operations/high-priority-backlog.md` の優先タスク一覧へ最優先で登録した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: 可視化資料タスクを既存 planned タスクより上位で着手する。
- 根拠資料: `docs/operations/high-priority-backlog.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__framework-request-to-commit-visual-guide` を着手して、フロー可視化資料と CLI/AI サンプル資料を作成する。
2. `2026-02-18__consistency-check-json-schema-version-policy` を着手して schema version 方針を確定する。
3. `2026-02-18__consistency-check-all-tasks-exclusion-rules` を着手して `-AllTasks` 除外条件を設計する。
4. `2026-02-18__validator-enhancement-backlog-reflection` を着手して validator 強化項目を運用資料へ反映する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
