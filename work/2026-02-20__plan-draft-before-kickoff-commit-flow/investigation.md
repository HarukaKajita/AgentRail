# Investigation: 2026-02-20__plan-draft-before-kickoff-commit-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 理解ポイント:
  - 固定フロー定義と可視化資料の間に順序不整合がある場合、運用誤解が発生する。

## 1. 調査対象 (Investigation Target) (必須)

- `plan-draft` と kickoff commit の前後関係が資料間で一致しているか。
- 起票境界コミットの定義が `plan-draft` 先行を満たしているか。
- 修正対象を docs で完結できるか。

## 2. 仮説 (Hypothesis) (必須)

- フロー図のみが逆順になっており、文書定義を `plan-draft` 先行へ統一すれば最小修正で解決できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 実施した確認:
  - 固定ワークフローに `plan-draft` が明示されていることを確認。
  - commit boundary 定義が「`request.md` / `investigation.md` / `spec.md` / `plan-draft` 完了時」であることを確認。
  - 可視化資料の mermaid で kickoff が `plan-draft` より前にある箇所を確認。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - `AGENTS.md` と `docs/operations/skills-framework-flow-guide.md` は `plan-draft` 先行の定義になっている。
  - `docs/operations/framework-request-to-commit-visual-guide.md` のフロー図だけが逆順（kickoff -> plan-draft）になっている。
- 推測:
  - 可視化資料の順序を修正し、あわせて文章でも `plan-draft` 先行を強調すれば運用誤解は解消できる。

## 5. 提案オプション (必須)

1. 図だけ修正:
   - mermaid の矢印順だけ直す。
2. 図 + ガイド文修正（採用）:
   - mermaid に加えて工程説明・commit boundary 説明の順序記述も明文化する。
3. checker 追加:
   - フロー図の順序を自動検査する仕組みを追加する。

## 6. 推奨案 (必須)

- 推奨: 2. 図 + ガイド文修正
- 理由:
  - 低コストで効果が高く、既存ルールとの整合を一気に回復できる。
  - checker 追加は過剰で、今回の修正目的に対して工数が大きい。

## 7. 結論 (Conclusion / 結論) (必須)

- 本件は docs 中の順序不整合修正として実装する。
- `plan-draft` を起票境界コミットの前提として明示し、図と文章の両方を揃える。

## 8. 未解決事項 (必須)

- なし。

## 9. 次アクション (必須)

1. `spec.md` で受入条件とテスト要件を確定する。
2. `plan.md` に `plan-draft / plan-final` を記載し実装手順を確定する。
3. docs 修正と検証を実施し、review/state を done へ更新する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
- spec: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/spec.md`
