# Investigation: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 理解ポイント:
  - 既存フローの必須工程を崩さずに、委譲制御をどこへ入れるかを調査する。

## 1. 調査対象 [空欄禁止]

- subagent / multi_agent を工程標準へ組み込む際の設計方式。
- 品質低下懸念工程の例外化ルール。
- 工程 md への記録方式と親エージェント返却フォーマット。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 原則委譲 + 例外工程固定 + 親エージェント再検証を標準化すれば、速度向上と品質維持を両立できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 実施した確認:
  - 固定ワークフローの順序と blocked 条件を確認。
  - コミット境界と依存関係ゲートの運用を確認。
  - スキル側に subagent 成果物フォーマットの共通定義が未整備であることを確認。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 固定工程は明確だが、subagent / multi_agent の利用規則は明文化されていない。
  - 品質責任の最終判断はレビュー工程に集中している。
  - 工程 md に委譲ログを残す統一セクションがない。
- 推測:
  - 委譲時コンテキストの不足が品質低下の主因になりやすい。
  - 高リスク工程は親固定とし、低〜中リスク工程を委譲対象にするのが現実的。

## 5. 提案オプション [空欄禁止]

1. 委譲最小:
   - 調査と草案作成だけ委譲する。
2. 標準委譲 + 例外（推奨）:
   - request/investigation/spec/plan/docs/test は原則委譲可能。
   - 受入判定、最終レビュー結論、state done 判定、コミット境界判断は親固定。
3. 段階導入:
   - まず 1 スキルで試行し、成功後に全体展開する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 標準委譲 + 例外
- 理由:
  - 早期に運用効果を得つつ、品質ゲートを維持できる。
  - 例外工程を明示することで責任分界を曖昧にしない。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクでは、subagent / multi_agent 利用を工程標準へ組み込む運用仕様を定義する。
- 例外工程・委譲コンテキスト・返却フォーマット・親側品質ゲートを `spec.md` で確定する。

## 8. 未解決事項 [空欄禁止]

- なし。

## 9. 次アクション [空欄禁止]

1. `spec.md` に例外工程マトリクスと返却契約を確定する。
2. `plan.md` で導入手順と検証手順を定義する。
3. backlog へ planned として優先登録する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
- spec: `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`
