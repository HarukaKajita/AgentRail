# Investigation: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/request.md`
- 理解ポイント:
  - Wave A は最優先（P1）で、共通 docs の DQ-002 warning 12 件を対象にする。

## 1. 調査対象 [空欄禁止]

- 課題:
  - `docs/specs/automation-tools-design-spec.md` で DQ-002 warning が集中発生している。
- 目的:
  - warning 発生箇所の傾向を把握し、最小変更で 12 件を解消する。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 関連リンクを `docs/*` と `work/*` の両方を含む構成へ補完すれば DQ-002 を解消できる。

## 3. 観測方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `docs/specs/automation-tools-design-spec.md`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  1. `-AllTasks -DocQualityMode warning -OutputFormat json` で対象ファイルと件数を確認する。
  2. 対象 docs の関連リンク節が `docs/*` 偏重になっていないか確認する。
  3. Wave A 修正後の残件（Wave B/C 対象）を再集計できる形式で記録する。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - Wave A 対象は `docs/specs/automation-tools-design-spec.md` の 12 件。
  - 全体 `dq002_count` は 21 件。
- 推測:
  - Wave A を完了すると残件は 9 件（Wave B 3 件 + Wave C 6 件）になる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- Wave A では対象 1 ファイルに集中してリンク補完を行い、最初に warning を 12 件削減する。

## 6. 未解決事項 [空欄禁止]

- 対象 docs のどの節に `work/*` 導線を追加するかの最終配置。

## 7. 次アクション [空欄禁止]

1. spec で削減目標（12 -> 0、総数 21 -> 9）を受入条件へ確定する。
2. plan-draft で修正順序と検証順序を固定する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/request.md`
- spec: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`
