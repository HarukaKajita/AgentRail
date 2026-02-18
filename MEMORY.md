# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__state-transition-validation
- タイトル: state.json 状態遷移検証
- 状態: done
- 最終更新日時: 2026-02-18T21:38:20+09:00
- 担当: Codex

## 2. 今回の目的

- state 専用 validator を追加し、許可 state・必須キー・done 整合条件を検証する。
- CI で全 task の state 検証を事前実行し、状態不整合を fail-fast する。
- 既存 done/planned/in_progress task で誤検知しない最小ルールを整備する。

## 3. 完了済み

- `tools/state-validate/validate.ps1` を新規追加し、`-TaskId` / `-AllTasks` モードを実装した。
- `state` 許可値、必須キー、`done` 時の review 完了整合（PENDING 残存なし）を検証するようにした。
- `.github/workflows/ci-framework.yml` に `Validate task states` step を追加した。
- 一時ディレクトリで正常/不正 state/欠落キー/done不整合のケースを実行し期待どおり PASS/FAIL を確認した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: state validator は初期段階として最小整合条件（必須キー + done時review整合）を採用する。
- 根拠資料: `work/2026-02-18__state-transition-validation/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__consistency-check-json-output` を実装する。
2. `2026-02-18__consistency-check-multi-task-mode` を実装する。
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
