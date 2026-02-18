# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__ci-task-resolution-no-fallback
- タイトル: CI task-id 解決の fallback 廃止
- 状態: done
- 最終更新日時: 2026-02-18T21:23:25+09:00
- 担当: Codex

## 2. 今回の目的

- task-id 解決を `manual` / `diff` / `skip` 契約へ整理し、fallback を廃止する。
- 差分 0 件時は checker 系 step を skip し、無関係 task への誤検査を防止する。
- `workflow_dispatch` の `task_id` 未指定を fail-fast にする。

## 3. 完了済み

- `tools/ci/resolve-task-id.ps1` から fallback 分岐を削除し、`workflow_dispatch` 未指定を fail-fast 化した。
- push 差分 0 件時に `source=skip` を返す挙動を追加した。
- `.github/workflows/ci-framework.yml` で `resolved_task_source` 条件により scan/check の実行可否を分岐した。
- `docs/specs/phase2-ci-integration-spec.md` / `docs/specs/phase2-automation-spec.md` / ADR を新ルールに更新した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: CI の task-id 解決は fallback を使わず、差分 0 件時は `skip` とする。
- 根拠資料: `docs/decisions/20260218-ci-governance-and-task-resolution.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__docs-indexer-check-mode` の実装計画を更新し、`-Mode check` を導入する。
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
