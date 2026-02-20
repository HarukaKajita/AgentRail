# Investigation: 2026-02-20__dq002-wave-c-fix-remaining-doc-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/request.md`
- 理解ポイント:
  - Wave C は DQ-002 remediation の最終波で、6 件を一括でゼロ化する。

## 1. 調査対象 [空欄禁止]

- 課題:
  - Wave B 完了後に残る 6 ファイル・6 件を解消する必要がある。
- 目的:
  - 各対象ファイルの導線不足を整理し、一括修正の順序を確定する。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 6 ファイルを同一パターン（docs/work 両導線補完）で処理すれば、`dq002_count=0` まで到達できる。

## 3. 観測方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `tools/consistency-check/check.ps1`
  - Wave C 対象 6 ファイル
- 実施した確認:
  1. Wave C 対象ファイル一覧を固定する。
  2. 各ファイルで不足しているリンク種別を確認する。
  3. Wave C 完了後の `dq002_count=0` を検証条件に設定する。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - Wave C 対象は 6 ファイル・各 1 件。
  - Wave B 完了が前提条件。
- 推測:
  - 6 ファイルを同一方針で修正すれば最終的に DQ-002 をゼロ化できる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- Wave C は 6 ファイル一括修正で DQ-002 remediation を完了させる。

## 6. 未解決事項 [空欄禁止]

- 6 ファイル間でリンク追加量の偏りが大きい場合の編集順。

## 7. 次アクション [空欄禁止]

1. spec で最終目標（6 -> 0、総数 6 -> 0）を受入条件へ確定する。
2. plan-draft で 6 ファイルの処理順序と検証順序を定義する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/request.md`
- spec: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`
