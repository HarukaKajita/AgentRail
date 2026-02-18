---
name: write_test_requirements
description: 受入条件を検証可能なテスト要件へ分解し、実施条件を明確化する。
---

このスキルは、`spec.md` のテスト要件を具体化するときに使う。

## いつ使うか

- 受入条件の検証方法が曖昧なとき
- テスト種別ごとの観点整理が必要なとき

## 入力

- `work/<task-id>/spec.md`
- `project.profile.yaml`

## 出力

- `work/<task-id>/spec.md` の `テスト要件` セクション更新
- Unit/Integration/Regression/Manual の各要件
- AC との対応と合格条件

## 禁止事項

- `テストする` のような抽象表現だけで完了扱いにしない
- profile 未定義コマンドを前提にしない
- 実施不能な要件を残さない
