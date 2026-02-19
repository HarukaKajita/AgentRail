# Investigation: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 理解ポイント:
  - 品質懸念を抑えるため、委譲範囲を狭める運用へ再設計する。

## 1. 調査対象 [空欄禁止]

- 委譲範囲を限定した場合の品質担保方式。
- request / investigation / spec を単一エージェントで処理する運用可否。
- 親再検討後にのみ次工程へ進めるゲート定義。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 委譲を3工程に限定し、親が spec 時点で再検討して `pass` を出す方式なら、速度と品質のバランスが最も良い。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 実施した確認:
  - 固定ワークフロー順序（request→investigation→spec→plan→...）を確認。
  - 高リスク判断（受入判定、done 判定、commit）が親責務であることを確認。
  - 委譲品質への懸念がユーザー要求として明示されたことを確認。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 全工程委譲は品質懸念により受容されない。
  - request / investigation / spec は草案生成と構造化の効果が高く、委譲適性がある。
  - plan 以降は意思決定密度が高く、親固定のほうが安全。
- 推測:
  - 単一エージェントで3工程を連続処理すれば文脈断絶を減らせる。
  - 親の再検討ゲートを spec 直後に置くことで、誤りの下流波及を抑制できる。

## 5. 提案オプション [空欄禁止]

1. 全面委譲:
   - 全工程を subagent / multi_agent に任せる。
2. 3工程限定委譲 + 親ゲート（推奨）:
   - request / investigation / spec を単一エージェントへ委譲。
   - 親が再検討して `gate_result=pass` の場合のみ plan 着手とコミットを許可。
3. 委譲停止:
   - すべて親実行に戻す。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 3工程限定委譲 + 親ゲート
- 理由:
  - 初期工程の作業効率を維持しつつ、品質判断を親で統制できる。
  - `spec` 時点で止められるため、下流工程の手戻りを抑えやすい。
  - コミット前に必ず親再検討を通すため品質責任が明確。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 委譲範囲は `request / investigation / spec` に限定する。
- 3工程は同一 `delegated_agent_id` で処理し、親が再検討して `gate_result=pass` なら plan と commit を許可する。
- `gate_result=fail` の場合は次工程禁止・差し戻しとする。

## 8. 未解決事項 [空欄禁止]

- なし。

## 9. 次アクション [空欄禁止]

1. `spec.md` を 3工程限定委譲モデルへ更新する。
2. `plan.md` を親ゲート前提の実施ステップへ更新する。
3. 整合チェックを再実行して仕様矛盾がないことを確認する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
- spec: `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`
