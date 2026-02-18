---
name: update_docs
description: 実装結果とレビュー結果を docs に反映し、INDEX と関連リンクを整合させる。
---

このスキルは、レビュー後に資料整合を確定するときに使う。

## いつ使うか

- タスク完了直前
- 仕様変更や意思決定の記録が増えたとき

## 入力

- `work/<task-id>/spec.md`
- `work/<task-id>/review.md`
- 変更済み資料一覧

## 出力

- 関連する `docs/*` の更新
- `docs/INDEX.md` の導線更新
- リンク整合の確認結果

## 禁止事項

- `docs/INDEX.md` を更新せずに完了扱いにしない
- 根拠のない要約を docs へ昇格しない
- 実装コードを変更しない
