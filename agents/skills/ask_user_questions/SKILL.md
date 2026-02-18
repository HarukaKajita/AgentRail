---
name: ask_user_questions
description: 要件確定や実装判断に必要な情報が不足しているときに、要求をブレインストーミングして提案3案と確認質問2-4件を作成し、work/<task-id>/investigation.md と state.json の blocked 反映方針を定義する。
---

# Ask User Questions

## 役割

不足情報を埋めるための質問だけを生成し、同時に解決案の選択肢を提示する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/request.md`
- `work/<task-id>/investigation.md`
- `work/<task-id>/spec.md` (存在する場合)

## 実行手順

1. 未確定事項を「仕様不足」「制約不足」「運用不足」に分類する。
2. 提案オプションを3案作る。
3. 推奨案を1つ選び、理由を記載する。
4. 確認質問を 2〜4 件作る。各質問に「回答で変わる判断」を明記する。
5. 質問待ちで停止が必要なら `state=blocked` を提案し、`blocking_issues` 候補を列挙する。
6. `investigation.md` へ追記すべき内容を提示する。

## 出力フォーマット

1. 提案オプション（3案）
2. 推奨案
3. 確認質問（2〜4件、優先度順）
4. blocked 判定（yes/no）と理由
5. `investigation.md` / `state.json` への反映案

## 禁止事項

- 推測で仕様を確定しない。
- 意思決定に影響しない質問をしない。
- `blocked` が必要なのに通常進行しない。
