---
name: Rail7:write-test-requirements
description: spec.md の受入条件を検証可能なテスト要件へ分解し、提案3案と確認質問2-4件を含めて Unit/Integration/Regression/Manual の実施条件を具体化する。
---

# Write Test Requirements

## 役割

受入条件を実施可能な検証条件へ変換する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/spec.md`
- `project.profile.yaml`

## 実行手順

1. AC 一覧を抽出し、テスト観点へ分解する。
2. テスト設計オプションを3案作る（最小 / 標準 / 強化）。
3. 推奨案を選び、Unit/Integration/Regression/Manual を具体化する。
4. AC と合格条件の対応を明示する。
5. profile に無い実行コマンドが必要な場合は確認質問 2〜4 件を作る。
6. 実施不能状態なら `blocked` を提案する。

## 出力フォーマット

1. テスト設計オプション（3案）
2. 推奨案
3. AC-テスト対応表
4. テスト要件詳細
5. 確認質問（2〜4件）
6. blocked 判定

## 禁止事項

- 抽象表現のみで完了扱いにしない。
- profile 未定義コマンドを前提にしない。
- 実施不能要件を放置しない。


