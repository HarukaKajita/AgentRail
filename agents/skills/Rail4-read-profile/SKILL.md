---
name: Rail4:read-profile
description: project.profile.yaml を読み取り、フレームワーク実行コマンドと必須キー整合を確認し、提案3案と確認質問2-4件を含む実行方針を作成する。
---

# Read Profile

## 役割

`project.profile.yaml` を唯一の実行契約として扱い、推測実行を防止する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `project.profile.yaml`
- `work/<task-id>/plan.md`
- `work/<task-id>/spec.md`

## 実行手順

1. profile の必須キーと値を確認する。
2. `commands` から build/test/format/lint と framework 専用コマンドを抽出する。
3. 実行順序の提案オプションを3案作る。
4. 推奨案を1つ選ぶ。
5. 不足キーや曖昧値がある場合、確認質問を 2〜4 件作る。
6. 不足により進行不能なら `blocked` を提案する。
7. `plan.md` と `spec.md` に反映すべき実行条件を明示する。

## 出力フォーマット

1. 抽出コマンド一覧
2. 実行戦略オプション（3案）
3. 推奨案
4. 確認質問（2〜4件）
5. blocked 判定
6. 反映先（`plan.md`, `spec.md`）

## 禁止事項

- profile にないコマンドを実行前提にしない。
- 必須キー不足を無視しない。
- 進行不能条件を曖昧にしない。


