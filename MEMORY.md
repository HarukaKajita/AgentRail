# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__ci-task-resolution-determinism
- タイトル: CI 対象 task-id 決定性強化
- 状態: done
- 最終更新日時: 2026-02-18T19:52:00+09:00
- 担当: Codex

## 2. 今回の目的

- CI の checker 対象 task-id を差分ベースで決定し、判定の再現性を高める。
- manual 指定、差分抽出、フォールバックの優先順を固定する。

## 3. 完了済み

- `tools/ci/resolve-task-id.ps1` を追加し、manual優先/差分抽出/フォールバックを実装。
- `.github/workflows/ci-framework.yml` を更新し、task-id 解決を新スクリプトへ移管。
- workflow に `workflow_dispatch` と `task_id` 入力を追加。
- `docs/specs/phase2-ci-integration-spec.md` と `docs/specs/phase2-automation-spec.md` を更新。
- `work/2026-02-18__ci-task-resolution-determinism/` を `done` へ更新。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: task-id 解決は manual指定 > 差分抽出 > フォールバック（ディレクトリ名降順先頭）の順とする。
- 根拠資料: `docs/specs/phase2-automation-spec.md`

## 5. 未解決・ブロッカー

- 追加の高優先改善（docs-indexer check / profile schema / state validation）は起票済みだが未着手。

## 6. 次アクション

1. `work/2026-02-18__docs-indexer-check-mode/` を着手する。
2. `work/2026-02-18__project-profile-schema-validation/` を着手する。
3. `work/2026-02-18__state-transition-validation/` を着手する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
