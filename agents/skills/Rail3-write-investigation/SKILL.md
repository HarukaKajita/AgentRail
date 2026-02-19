---
name: Rail3:write-investigation
description: work/<task-id>/investigation.md を作成・更新し、仮説・観測方法・観測結果・結論を事実ベースで確定する。判断不能点は確認質問2-4件と blocked 提案で扱う。
---

# Write Investigation

## 役割

実装判断の根拠を、再検証可能な調査記録として固定する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/request.md`
- `work/<task-id>/investigation.md` (存在する場合)
- 関連する `docs/*` と `tools/*`

## 実行手順

1. 調査対象と仮説を明確化する。
2. 観測方法を具体化し、確認対象ファイルやコマンドを定義する。
3. 観測結果を「事実」と「推測」に分離して記録する。
4. 提案オプションを3案作る（最小変更 / バランス / 強化）。
5. 推奨案を1つ選び、採用理由を記載する。
6. 結論、未解決事項、次アクションを確定する。
7. 不足情報が残る場合は確認質問 2〜4 件を提示する。
8. 実装判断が確定不能なら `blocked` を提案する。
9. Subagent delegation governance が有効な task では、単一 `delegated_agent_id` を維持し、spec と plan-draft へ渡す delegation context を更新する。
10. 親の `gate_result=pass` 前は kickoff commit / depends_on gate / plan-final へ進まない前提で結論を記録する。

## 出力フォーマット

1. 調査対象と仮説
2. 観測方法
3. 観測結果（事実 / 推測）
4. 提案オプション（3案）
5. 推奨案
6. 結論・未解決事項・次アクション
7. 確認質問（2〜4件）
8. blocked 判定

## 禁止事項

- 根拠のない断定をしない。
- 観測手順を省略しない。
- 未解決事項を隠したまま次工程へ進めない。

