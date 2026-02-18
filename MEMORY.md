# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__consistency-check-json-output
- タイトル: consistency-check JSON 出力対応
- 状態: done
- 最終更新日時: 2026-02-18T22:27:44+09:00
- 担当: Codex

## 2. 今回の目的

- consistency-check に `-OutputFormat json` と `-OutputFile` を追加し、機械可読連携を可能にする。
- text/json の出力を同一結果モデルから生成して情報不整合を防ぐ。
- 失敗時でも JSON を返し、従来どおり終了コード1を維持する。

## 3. 完了済み

- `tools/consistency-check/check.ps1` に `-OutputFormat text|json` と `-OutputFile` を追加した。
- JSON payload に `task_id`, `status`, `failure_count`, `failures[]` を実装した。
- 既定 text 出力（`CHECK_RESULT` 形式）を維持したまま JSON 出力を追加した。
- docs へ JSON スキーマと利用コマンド例を反映した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: checker の JSON 出力は text 出力と同一結果モデルを共有し、終了コード契約は変更しない。
- 根拠資料: `work/2026-02-18__consistency-check-json-output/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__consistency-check-multi-task-mode` を実装する。
2. consistency-check の JSON schema version 運用方針を必要に応じて追加する。
3. validator 群（profile/state）の将来強化項目を backlog へ反映する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
