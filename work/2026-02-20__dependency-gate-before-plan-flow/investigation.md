# Investigation: 2026-02-20__dependency-gate-before-plan-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 計画2段階化は docs/skills/checker の仕様同期が必要。

## 1. 調査対象 [空欄禁止]

- 依存未解決時に詳細計画が無効化される問題。
- `plan-draft` の必要性と `plan-final` の確定条件。
- ベストプラクティスとしての Definition of Ready との整合。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `plan-draft -> depends_on gate -> plan-final` へ変更すれば、探索に必要な初期計画を維持しながら、前提未解決の詳細計画確定を防げる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md`
  - `work/2026-02-19__task-dependency-aware-prioritization-flow/plan.md`
- 実施した確認:
  - 固定ワークフロー順序を確認。
  - depends_on 解決判定仕様（依存先 `done`）を確認。
  - `plan` 先行確定時の再計画リスクを確認。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 依存調査には軽量計画が有効だが、詳細計画の早期確定は破綻しやすい。
  - depends_on 判定仕様は既に存在し、ゲート化できる。
  - 計画フェーズを分離すれば、再計画対象を `plan-final` のみに限定できる。
- 推測:
  - `plan-draft` を許容し `plan-final` を gate 後に制約する設計が最も実務的。

## 5. 提案オプション（3案） [空欄禁止]

1. 1段階計画:
   - depends_on 解決後にのみ `plan` 作成。
2. 2段階計画（採用）:
   - `plan-draft` を `spec` 後に作成し、gate pass 後に `plan-final` を確定。
3. 現行維持:
   - `plan` 後に依存確認して必要時に再計画。

## 6. 推奨案 [空欄禁止]

- 採用: オプション2（2段階計画）
- 理由:
  - 依存調査に必要な初期計画を残し、確定計画は依存解決後に限定できる。
  - 手戻り削減と進行可能性の見積もりを両立できる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- フローを `request -> investigation -> spec -> plan-draft -> depends_on gate -> plan-final -> implementation` に変更する。
- `plan-final` は gate pass 時のみ確定し、gate fail 時は `dependency-blocked` として差し戻す。

## 8. 未解決事項 [空欄禁止]

- なし。

## 9. 次アクション [空欄禁止]

1. `spec.md` に `plan-draft` と `plan-final` の契約を定義する。
2. `plan.md` に2段階計画の実装手順と検証手順を定義する。
3. backlog と memory へ起票内容を同期する。

## 10. 確認質問（2〜4件） [空欄禁止]

- なし。

## 11. blocked 判定 [空欄禁止]

- blocked ではない。

## 12. 関連リンク [空欄禁止]

- request: `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
- spec: `work/2026-02-20__dependency-gate-before-plan-flow/spec.md`
