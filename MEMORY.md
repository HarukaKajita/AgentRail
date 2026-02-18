# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__framework-pilot-01
- タイトル: Phase 1 運用開始パイロット
- 状態: done
- 最終更新日時: 2026-02-18T18:05:00+09:00
- 担当: Codex

## 2. 今回の目的

- `project.profile.yaml` の必須項目を実値化し、厳格ブロックを解除する。
- 実タスクを 1 件通しで実施し、フレームワーク運用の再現性を確認する。

## 3. 完了済み

- `work/2026-02-18__framework-pilot-01/` の必須 6 ファイルを作成し、全項目を記入。
- `docs/specs/framework-pilot-01-spec.md` を追加。
- `docs/investigations/framework-pilot-01-investigation.md` を追加。
- `docs/specs/phase2-automation-spec.md` を追加（設計のみ）。
- `docs/INDEX.md` を更新して導線を追加。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: 次ステップは運用開始優先。Phase 2 は実装せず設計のみ確定。
- 根拠資料: フレームワーク設計と実装についてのChatGPTとの会話.md

## 5. 未解決・ブロッカー

- `docs-indexer` と `consistency-check` の実装は未着手（仕様のみ確定）。

## 6. 次アクション

1. Phase 2 実装タスクを起票し、`docs/specs/phase2-automation-spec.md` をベースに詳細化する。
2. `project.profile.yaml` のコマンドを CI に接続する方針を決定する。
3. 2 件目の実タスクをこのフレームワークで実施し、改善点を抽出する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
