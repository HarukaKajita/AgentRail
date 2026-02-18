# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__self-improvement-loop-enforcement
- タイトル: 自己改善ループ強制の実装
- 状態: done
- 最終更新日時: 2026-02-18T19:25:21+09:00
- 担当: Codex

## 2. 今回の目的

- Process Findings をフロー必須項目にして改善漏れを防止する。
- `must/high` の finding を必ず follow-up task に接続する。
- CI で scan/check を実行し未起票を fail-fast する。

## 3. 完了済み

- `tools/improvement-harvest/scan.ps1` を追加し review findings を検証・抽出可能にした。
- `tools/improvement-harvest/create-task.ps1` を追加し follow-up task の6ファイル雛形生成を自動化した。
- `tools/consistency-check/check.ps1` に改善ゲート（3ルール）を追加した。
- `.github/workflows/ci-framework.yml` に scan step を追加した。
- `docs/templates/review.md` と関連 docs/spec/operations を更新した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: `must/high` finding は `action_required: yes` と `linked_task_id` を必須化する。
- 根拠資料: `docs/decisions/20260218-self-improvement-loop-enforcement.md`

## 5. 未解決・ブロッカー

- 既存 task の review 書式移行は段階実施（新規/更新 task から適用）。

## 6. 次アクション

1. `2026-02-18__docs-indexer-check-mode` を実装して F-001 をクローズする。
2. `2026-02-18__project-profile-schema-validation` を実装する。
3. `2026-02-18__state-transition-validation` を実装する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
