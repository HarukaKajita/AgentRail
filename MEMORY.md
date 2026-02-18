# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__framework-request-to-commit-visual-guide
- タイトル: ユーザー要望から実装・コミットまでのフロー可視化資料作成
- 状態: done
- 最終更新日時: 2026-02-19T00:39:32+09:00
- 担当: Codex

## 2. 今回の目的

- 要望提示から実装・コミットまでのフレームワーク内イベントを図解した資料を提供する。
- CLI 要望サンプルと AI 応答サンプルを含む、初見ユーザー向け運用ガイドを完成させる。
- 資料追加後の INDEX 導線・タスク状態・レビュー結果を整合させる。

## 3. 完了済み

- `docs/operations/framework-request-to-commit-visual-guide.md` を追加し、Mermaid 図・工程解説・CLI/AI サンプルを実装した。
- `docs/INDEX.md` を更新し、運用セクションから新規資料へ遷移できる導線を追加した。
- `work/2026-02-18__framework-request-to-commit-visual-guide/{investigation,plan,review,state.json}` を更新し、完了判定を記録した。
- `docs/operations/high-priority-backlog.md` で当該タスクを Completed へ移動した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: 可視化資料タスクを最優先で完了し、以降は残り planned タスクを優先順で着手する。
- 根拠資料: `docs/operations/high-priority-backlog.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__consistency-check-json-schema-version-policy` を着手して schema version 方針を確定する。
2. `2026-02-18__consistency-check-all-tasks-exclusion-rules` を着手して `-AllTasks` 除外条件を設計する。
3. `2026-02-18__validator-enhancement-backlog-reflection` を着手して validator 強化項目を運用資料へ反映する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
