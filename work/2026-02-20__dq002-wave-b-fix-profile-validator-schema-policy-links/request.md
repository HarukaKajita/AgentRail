# Request: 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`
- 理解ポイント:
  - Wave B は Wave A 完了後に着手する P2 タスク。

## 要望の原文

- `docs/operations/profile-validator-schema-version-policy.md` の DQ-002 warning 3 件を解消する。

## 要望分析

- 直要求:
  - Wave B 対象 1 ファイル（3 件）を修正する。
- 潜在要求:
  - Wave C の最終バッチに向けて warning 残件を 6 件まで圧縮する。
- 非要求:
  - Wave A/C 対象ファイルの修正。

## 成功条件（要望レベル）

1. `docs/operations/profile-validator-schema-version-policy.md` の DQ-002 warning が 3 件から 0 件へ減少する。
2. `-AllTasks -DocQualityMode warning -OutputFormat json` の `dq002_count` が 9 から 6 へ減少する。
3. Wave A 完了を前提に依存関係が明示された起票状態を維持する。

## blocked 判定

- depends_on: `2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links`
- Wave A 未完了のため、起票時点は `dependency-blocked`。
