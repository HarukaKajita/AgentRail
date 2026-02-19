# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__profile-version-schema-version-unification-strategy
- タイトル: Profile Version Schema Version Unification Strategy
- 状態: planned
- 最終更新日時: 2026-02-19T15:58:57+09:00
- 担当: Codex

## 2. 今回の目的

- `version` と `schema_version` の将来統合方針を実装可能な粒度で定義する。
- 正本フィールド・移行期間・廃止条件を明確化する。
- 新規 planned task と backlog 導線を起票する。

## 3. 完了済み

- `work/2026-02-19__profile-version-schema-version-unification-strategy/` を新規作成し、必須6ファイルを起票した。
- `docs/operations/validator-enhancement-backlog.md` に VE-005 を `planned` で追加した。
- `docs/operations/high-priority-backlog.md` の優先タスク一覧へ本タスクを追加した。
- 新タスク文書の整合が取れるよう request/investigation/spec/plan を具体化した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: 統合方針タスクを VE-005 として起票し、次の着手対象を `2026-02-19__profile-version-schema-version-unification-strategy` に設定する。
- 根拠資料: `docs/operations/high-priority-backlog.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-19__profile-version-schema-version-unification-strategy` の実装（方針確定）に着手する。
2. 方針確定後に validator 実装タスクへ分解する。
3. 既存 docs（policy/template）との整合を再確認する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
