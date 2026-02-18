---
name: write_spec
description: docs/templates/spec.md に従って work/<task-id>/spec.md を作成・更新する。
---

このスキルは、要件を実装可能な仕様へ確定するときに使う。

## いつ使うか

- 調査結果を要件化するとき
- 受入条件を明文化するとき

## 入力

- `work/<task-id>/request.md`
- `work/<task-id>/investigation.md`
- `docs/templates/spec.md`

## 出力

- `work/<task-id>/spec.md`（空欄禁止項目を全て記入）
- 受入条件（AC）とテスト要件の対応表

## 禁止事項

- 空欄禁止項目を未記入のまま完了扱いにしない
- 調査に存在しない内容を断定しない
- 実装コードを書かない
