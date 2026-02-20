# Request: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- 理解ポイント:
  - 本タスクは DQ-002 warning 解消の Wave A（P1）であり、最初に着手する。

## 要望の原文

- `docs/specs/automation-tools-design-spec.md` に集中している DQ-002 warning を優先解消する。

## 要望分析

- 直要求:
  - Wave A 対象 1 ファイル（12件）を修正し、共通 docs の導線不足を解消する。
- 潜在要求:
  - 後続 Wave B/C の依存基盤を整える。
- 非要求:
  - DQ-002 以外の rule（DQ-001/003/004）変更。

## 成功条件（要望レベル）

1. `docs/specs/automation-tools-design-spec.md` の DQ-002 warning が 12 件から 0 件へ減少する。
2. `-AllTasks -DocQualityMode warning -OutputFormat json` の `dq002_count` が 21 から 9 へ減少する。
3. 修正方針と検証結果を task docs（request/investigation/spec/plan/review/state）へ記録できる。

## blocked 判定

- depends_on はなし。`plan-ready` で起票する。
