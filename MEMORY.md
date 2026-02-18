# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__phase2-ci-integration
- タイトル: Phase 2 後半 CI 連携（GitHub Actions）
- 状態: done
- 最終更新日時: 2026-02-18T19:05:00+09:00
- 担当: Codex

## 2. 今回の目的

- `docs-indexer` と `check_consistency` を GitHub Actions に統合する。
- INDEX 差分検出と latest task-id 自動解決を CI ゲートとして導入する。

## 3. 完了済み

- `.github/workflows/ci-framework.yml` を追加し、push/pull_request で framework チェックを自動化。
- CI で `docs-indexer` 実行後の `docs/INDEX.md` 差分検出を導入。
- CI で `work/` 配下から latest task-id を自動解決して `check_consistency` を実行。
- `work/2026-02-18__phase2-ci-integration/` の必須 6 ファイルを作成し完了。
- `docs/specs/phase2-ci-integration-spec.md` と `docs/investigations/phase2-ci-integration-investigation.md` を追加。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: CI 基盤は GitHub Actions。task-id は latest task 自動解決。INDEX 差分は失敗扱い。
- 根拠資料: `docs/specs/phase2-automation-spec.md`

## 5. 未解決・ブロッカー

- 次の優先改善（3件）は起票済みだが未着手。

## 6. 次アクション

1. `work/2026-02-18__ci-task-resolution-determinism/` を着手し、CIのtask-id解決を差分ベースへ変更する。
2. `work/2026-02-18__consistency-check-multi-task-mode/` を着手し、checkerの複数task走査を実装する。
3. `work/2026-02-18__consistency-check-json-output/` を着手し、checkerのJSON出力を実装する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
