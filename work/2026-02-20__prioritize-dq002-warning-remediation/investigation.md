# Investigation: 2026-02-20__prioritize-dq002-warning-remediation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `tools/consistency-check/check.ps1`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
- 理解ポイント:
  - DQ-002 は docs/work 双方向導線不足を示す警告であり、実装順序の定義が必要。

## 1. 調査対象 [空欄禁止]

- 課題: DQ-002 warning 21件に対する解消順序が未定義。
- 目的: 優先度判定軸と起票分割方針を確定する。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- warning を docs領域/影響範囲で分類し、優先度基準を先に固定すれば計画的に解消できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/specs/automation-tools-design-spec.md`
- 実施した確認:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` で warning 発生対象を再確認する。
  2. warning 発生 docs の責務カテゴリ（運用/仕様/調査）を分類する。
  3. 波及影響（関連 task 数、参照頻度）で優先順位候補を比較する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - DQ-002 warning は 21件で継続し、主に `docs/specs/automation-tools-design-spec.md` と運用 docs に集中している。
  - 現行 backlog には DQ-002 解消専用の分割計画がない。
- 推測:
  - 影響範囲の大きい共通 docs から着手する順序が最短。

## 5. 提案オプション [空欄禁止]

1. 発生順で対応する。
2. docs の参照影響度順で対応する（推奨）。
3. task 作成日順で対応する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 参照影響度順
- 理由:
  - 影響が大きい docs を先に是正すると warning 減少効果が高い。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- DQ-002 warning を「共通仕様 docs 優先 -> 運用 docs -> 個別補完」の3段に分けて起票する。

## 8. 未解決事項 [空欄禁止]

- 各分割タスクの最終粒度（1タスクあたり修正ファイル数）。

## 9. 次アクション [空欄禁止]

1. 優先度基準を spec に固定する。
2. plan-draft に分割起票順と検証順を定義する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
- spec: `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- docs:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
