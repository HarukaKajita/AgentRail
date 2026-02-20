---
name: Rail1:write-request
description: ユーザー要望を work/<task-id>/request.md 向けに具体化し、短すぎる要求の拡張提案と大きすぎる要求の分割提案を行って、実装可能なスコープへ合理的に確定する。
---

# Write Request

## 役割

要望の粒度とスコープを制御し、後続工程が迷わない `request.md` を作る。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- ユーザーの最新要望
- `work/<task-id>/request.md` (存在する場合)
- `docs/INDEX.md` (関連資料の参照先確認)

## 実行手順

1. 要望を「直要求」「潜在要求」「非要求」に分解する。
2. 要望ボリュームを判定する（不足 / 適正 / 過大）。
3. 提案オプションを3案作る（具体化重視 / 価値拡張 / 分割実行）。
4. 推奨案を1つ選び、採用理由と非採用理由を明示する。
5. 要望が過大な場合は、分割後のサブ要求一覧と実施順序を提案する。
6. 未確定点のみ確認質問 2〜4 件を作る。
7. 着手前完了が必要な依存 task を調査し、`depends_on` 候補を明示する。
8. `request.md` に反映する確定要望、非要望、境界条件を明示する。
9. 依存先 task が不足する場合は追加起票を提案し、未解決なら `blocked` を提案する。
10. 起票境界が確定したら、コミット境界前チェックを提案する。
   - `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase kickoff`
11. Subagent delegation governance が有効な task では、以下を満たす。
   - 対象フェーズは request / investigation / spec / plan-draft の4工程。
   - 4工程は単一 `delegated_agent_id` で連続実行する。
   - `request.md` には後続フェーズに引き渡す delegation context（task_id / delegated_agent_id / objective / constraints / acceptance）を残す。
   - 親の `gate_result=pass` 前は kickoff commit に進まない。

## 出力フォーマット

1. 要望分析（直要求 / 潜在要求 / 非要求）
2. 提案オプション（3案）
3. 推奨案
4. 分割提案（必要時）
5. 確認質問（2〜4件）
6. 依存関係整理（depends_on 候補 / 不足依存）
7. `request.md` 反映案
8. blocked 判定

## 禁止事項

- 要望を曖昧なまま `request.md` へ確定しない。
- 分割不要な要望を過剰分割しない。
- 要望不足を推測で補完しない。

