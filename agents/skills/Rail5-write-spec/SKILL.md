---
name: Rail5:write-spec
description: docs/templates/spec.md に従って work/<task-id>/spec.md を作成・更新し、要求のブレインストーミング結果を提案3案・確認質問2-4件とともに受入条件とテスト要件へ確定する。
---

# Write Spec

## 役割

要求を実装可能で検証可能な仕様へ落とし込む。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/request.md`
- `work/<task-id>/investigation.md`
- `docs/templates/spec.md`

## 実行手順

1. 要求を「直要求」「潜在要求」「非要求」に分解する。
2. 実現方針の提案オプションを3案作る。
3. 推奨案を1つ選び、スコープを確定する。
4. AC とテスト要件の対応を 1:1 で定義する。
5. 空欄禁止項目を全て埋める。
6. なお未確定の判断点だけを確認質問 2〜4 件に絞る。
7. 未確定が実装阻害なら `blocked` を提案する。

## 出力フォーマット

1. スコープ確定結果
2. 提案オプション（3案）
3. 推奨案
4. AC-テスト要件対応表
5. 確認質問（2〜4件）
6. blocked 判定

## 禁止事項

- 空欄禁止項目を残したまま完了扱いにしない。
- 調査にない内容を断定しない。
- 実装コードを書かない。


