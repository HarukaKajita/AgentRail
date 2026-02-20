# 仕様書: 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/request.md`
  - `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/investigation.md`
- 理解ポイント:
  - Wave B は Wave A 完了後に DQ-002 warning を 3 件削減する依存タスク。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links
- タイトル: DQ-002 Wave B: profile-validator-schema policy links remediation
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/request.md`
- 依存タスク: `2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景:
  - `docs/operations/profile-validator-schema-version-policy.md` に DQ-002 warning 3 件が残る。
- 目的:
  - Wave B を完了し、Wave C 最終バッチの残件を 6 件へ圧縮する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/operations/profile-validator-schema-version-policy.md` の DQ-002 warning 3 件を解消する。
- Wave B 完了後の全体件数を再集計する。

### 3.2 Out of Scope (必須)

- Wave A/C 対象ファイルの修正。
- DQ-002 以外の doc quality rule 修正。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001:
  - `docs/operations/profile-validator-schema-version-policy.md` の DQ-002 warning が 3 件から 0 件に減少する。
- AC-002:
  - `-AllTasks -DocQualityMode warning -OutputFormat json` の `dq002_count` が 9 から 6 へ減少する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `docs/operations/profile-validator-schema-version-policy.md`
- **検証項目**: DQ-002 判定条件を満たすリンク構成になっている
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning` が PASS

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: 全体集計
- **検証項目**: Wave B 適用後の総件数減少
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json` で `dq002_count=6`

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: task state と docs index 整合
- **検証項目**: Wave B の task docs 更新が検証ルールを壊さない
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning` が PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. Wave B 対象 docs の関連リンク節を確認
  2. 全体 `dq002_count` が 6 件であることを確認
- **期待される結果**:
  - AC-001 と AC-002 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
  - `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/*`
- 影響する仕様:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
- 非機能影響:
  - 段階的修正（Wave B）の進捗可視性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約:
  - Wave A 完了前に実装へ進まない
- 想定リスク:
  - Wave B 着手前に総件数想定がずれる
- 回避策:
  - 着手前に `-AllTasks` を再実行し基準値を確認する

## 8. 未確定事項 (Open Issues) (必須)

- なし（依存関係と対象件数は確定済み）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/request.md`
- investigation: `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/investigation.md`
- plan: `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/plan.md`
- review: `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/review.md`
- docs:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/high-priority-backlog.md`
