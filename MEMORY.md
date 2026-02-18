# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__consistency-check-multi-task-mode
- タイトル: consistency-check 複数 task 走査モード
- 状態: done
- 最終更新日時: 2026-02-18T22:35:58+09:00
- 担当: Codex

## 2. 今回の目的

- consistency-check を複数 task 対応（`-TaskIds`, `-AllTasks`）へ拡張する。
- 単一 task モードの後方互換を保ちながら task単位サマリを出力する。
- 複数走査で FAIL が含まれる場合に終了コード1を返す集計ロジックを導入する。

## 3. 完了済み

- `tools/consistency-check/check.ps1` を関数化し、`-TaskId`, `-TaskIds`, `-AllTasks` の parameter set を実装した。
- 複数モードで task ごとの PASS/FAIL サマリと failure 集計を出力するようにした。
- 既存単一モードの `CHECK_RESULT` 出力互換を維持した。
- docs に複数taskモードの入力/出力/コマンド例を反映した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: 複数taskモードでも単一モード互換を最優先し、CI既定呼び出しは `-TaskId` を維持する。
- 根拠資料: `work/2026-02-18__consistency-check-multi-task-mode/spec.md`

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
