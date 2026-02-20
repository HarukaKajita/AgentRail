# Investigation: 2026-02-20__prioritize-dq002-warning-remediation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `tools/consistency-check/check.ps1`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
- 理解ポイント:
  - DQ-002 は docs/work 双方向導線不足を示す警告であり、実装順序の定義が必要。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: DQ-002 warning 21件に対する解消順序が未定義。
- 目的: 優先度判定軸と起票分割方針を確定する。

## 2. 仮説 (Hypothesis) (必須)

- warning を docs領域/影響範囲で分類し、優先度基準を先に固定すれば計画的に解消できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/specs/automation-tools-design-spec.md`
- 実施した確認:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` で warning 発生対象を再確認する。
  2. warning 発生 docs の責務カテゴリ（運用/仕様/調査）を分類する。
  3. 波及影響（関連 task 数、参照頻度）で優先順位候補を比較する。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - DQ-002 warning は 21件で継続している。
  - 集中先は以下の8ファイルである。
    - `docs/specs/automation-tools-design-spec.md`（12件）
    - `docs/operations/profile-validator-schema-version-policy.md`（3件）
    - `docs/investigations/self-improvement-loop-investigation.md`（1件）
    - `docs/operations/profile-validator-required-checks-source-of-truth.md`（1件）
    - `docs/operations/runtime-distribution-export-guide.md`（1件）
    - `docs/operations/runtime-installation-runbook.md`（1件）
    - `docs/operations/state-history-strategy.md`（1件）
    - `docs/operations/state-validator-done-docs-index-consistency.md`（1件）
  - 現行 backlog には DQ-002 解消専用の分割計画がない。
- 推測:
  - 影響範囲の大きい共通 docs から着手する順序が最短。

## 5. 提案オプション (必須)

1. 発生順で対応する。
2. docs の参照影響度順で対応する（推奨）。
3. task 作成日順で対応する。

## 6. 推奨案 (必須)

- 推奨: 2. 参照影響度順
- 理由:
  - 影響が大きい docs を先に是正すると warning 減少効果が高い。

## 7. 結論 (Conclusion / 結論) (必須)

- DQ-002 warning を「Wave A（共通仕様）-> Wave B（運用ポリシー）-> Wave C（個別補完）」で分割して起票する。

## 8. 未解決事項 (必須)

- 各分割タスクの最終粒度（1タスクあたり修正ファイル数）。

## 9. 次アクション (必須)

1. 優先度基準を `docs/operations/dq002-warning-remediation-priority-plan.md` に反映する。
2. plan-final と review を更新して task を done 化する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
- spec: `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- docs:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
