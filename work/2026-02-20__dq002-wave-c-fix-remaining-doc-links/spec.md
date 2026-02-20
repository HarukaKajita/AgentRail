# 仕様書: 2026-02-20__dq002-wave-c-fix-remaining-doc-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/request.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/investigation.md`
- 理解ポイント:
  - Wave C は DQ-002 remediation 最終波で、全体 `dq002_count=0` を達成する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__dq002-wave-c-fix-remaining-doc-links
- タイトル: DQ-002 Wave C: remaining docs links remediation
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/request.md`
- 依存タスク: `2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links`

## 2. 背景と目的 [空欄禁止]

- 背景:
  - Wave B 完了後に残る DQ-002 warning は 6 ファイル・6 件。
- 目的:
  - Wave C を完了し、DQ-002 warning をゼロ化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 以下 6 ファイルの DQ-002 warning を解消する。
- `docs/investigations/self-improvement-loop-investigation.md`
- `docs/operations/profile-validator-required-checks-source-of-truth.md`
- `docs/operations/runtime-distribution-export-guide.md`
- `docs/operations/runtime-installation-runbook.md`
- `docs/operations/state-history-strategy.md`
- `docs/operations/state-validator-done-docs-index-consistency.md`

### 3.2 Out of Scope [空欄禁止]

- DQ-002 以外の warning ルール対応。
- Wave A/B 対象 docs の追加変更。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001:
  - Wave C 対象 6 ファイルの DQ-002 warning が 6 件から 0 件へ減少する。
- AC-002:
  - `-AllTasks -DocQualityMode warning -OutputFormat json` で `dq002_count=0` を達成する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: Wave C 対象 6 ファイル
- 観点: 各 docs が DQ-002 判定条件を満たす
- 合格条件:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning` が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 全タスク一括チェック
- 観点: DQ-002 総件数ゼロ化
- 合格条件:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json` で `dq002_count=0`

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: task state と docs index 整合
- 観点: Wave C task docs 更新で既存検証が壊れない
- 合格条件:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning` が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. Wave C 対象 6 ファイルの関連リンク節を目視確認
  2. `dq002_count=0` を確認
- 期待結果:
  - AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - Wave C 対象 6 ファイル
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/*`
- 影響する仕様:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
- 非機能影響:
  - DQ-002 remediation 完了後の運用安定性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約:
  - Wave B 完了まで実装着手しない
- 想定リスク:
  - 6 ファイル中の一部見落としで `dq002_count=0` に到達しない
- 回避策:
  - 完了判定は必ず `-AllTasks -OutputFormat json` で行う

## 8. 未確定事項 [空欄禁止]

- なし（対象ファイル・目標値は確定済み）。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/request.md`
- investigation: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/investigation.md`
- plan: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/plan.md`
- review: `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/review.md`
- docs:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/high-priority-backlog.md`
