# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__project-profile-schema-validation
- タイトル: project.profile.yaml スキーマ検証
- 状態: done
- 最終更新日時: 2026-02-18T21:34:07+09:00
- 担当: Codex

## 2. 今回の目的

- profile 専用 validator を追加し、必須キー欠落と禁止値 (`TODO_SET_ME`) を早期検出する。
- CI に validator step を組み込み、task 解決・checker 実行前に fail-fast する。
- profile 検証ロジックを独立化して、失敗原因の可観測性を高める。

## 3. 完了済み

- `tools/profile-validate/validate.ps1` を新規追加し、必須キー検証と `TODO_SET_ME` 検知を実装した。
- `.github/workflows/ci-framework.yml` に `Validate project profile` step を追加した。
- `docs/specs/phase2-ci-integration-spec.md` / `docs/specs/phase2-automation-spec.md` を validator 導入後の手順へ更新した。
- 一時ディレクトリで正常/欠落/TODO の3ケースを実行し、期待どおり PASS/FAIL を確認した。

## 4. 重要な意思決定

- 日付: 2026-02-18
- 決定内容: profile 検証は checker 依存を減らし、専用 validator を CI の前段で実行する。
- 根拠資料: `work/2026-02-18__project-profile-schema-validation/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__state-transition-validation` の実装計画を更新し、state validator を追加する。
2. `2026-02-18__consistency-check-json-output` を実装する。
3. `2026-02-18__consistency-check-multi-task-mode` を実装する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
