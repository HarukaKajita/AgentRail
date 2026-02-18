# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__docs-indexer-check-mode
- タイトル: docs-indexer check モード追加
- 状態: done
- 最終更新日時: 2026-02-18T21:27:16+09:00
- 担当: Codex

## 2. 今回の目的

- `docs-indexer` に `-Mode apply|check` を追加し、CI で非破壊検証を行えるようにする。
- `check` で差分検出時は終了コード1、差分なしは0の明確な契約を提供する。
- workflow から `apply + git diff` 依存を外し、`check` モードを直接利用する。

## 3. 完了済み

- `tools/docs-indexer/index.ps1` に `-Mode apply|check` を追加した。
- `check` モードで非破壊比較のみを実施し、差分あり時は FAIL/exit 1 とした。
- `.github/workflows/ci-framework.yml` の docs step を `-Mode check` 呼び出しへ切り替えた。
- CI連携仕様 docs を `check` モード前提に更新した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: CI の docs 検証は `docs-indexer -Mode check` を正本とし、書き込み判定に依存しない。
- 根拠資料: `docs/specs/phase2-ci-integration-spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__project-profile-schema-validation` の実装計画を更新し、validator を追加する。
2. `2026-02-18__state-transition-validation` を実装する。
3. `2026-02-18__consistency-check-json-output` と `multi-task-mode` の順で整備する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
