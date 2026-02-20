# Request: 2026-02-20__dq002-wave-c-fix-remaining-doc-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/investigations/self-improvement-loop-investigation.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - Wave C は最終バッチで、残存 6 ファイル・6 件を解消して `dq002_count=0` を達成する。

## 要望の原文

- Wave C 対象の 6 ファイルを一括修正し、DQ-002 warning をゼロ化する。

## 要望分析

- 直要求:
  - 以下 6 ファイル（各 1 件）を修正する。
  - `docs/investigations/self-improvement-loop-investigation.md`
  - `docs/operations/profile-validator-required-checks-source-of-truth.md`
  - `docs/operations/runtime-distribution-export-guide.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/state-history-strategy.md`
  - `docs/operations/state-validator-done-docs-index-consistency.md`
- 潜在要求:
  - DQ-002 remediation wave を完全完了し、後続運用を warning-free に近づける。
- 非要求:
  - DQ-002 以外の warning を同時解消すること。

## 成功条件（要望レベル）

1. Wave C 対象 6 ファイルの DQ-002 warning が 6 件から 0 件へ減少する。
2. `-AllTasks -DocQualityMode warning -OutputFormat json` で `dq002_count=0` を達成する。
3. backlog と MEMORY に Wave A/B/C 完了の進捗が同期される。

## blocked 判定

- depends_on: `2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links`
- Wave B 未完了のため、起票時点は `dependency-blocked`。
