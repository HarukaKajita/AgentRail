# 仕様書: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/request.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/investigation.md`
- 理解ポイント:
  - Wave A は DQ-002 warning 21 件のうち 12 件を削減する最優先タスク。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links
- タイトル: DQ-002 Wave A: automation-tools-design-spec links remediation
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/request.md`
- 依存タスク: なし

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景:
  - `docs/specs/automation-tools-design-spec.md` に DQ-002 warning が 12 件集中している。
- 目的:
  - Wave A を完了し、全体解消の起点となる warning を最短で削減する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/specs/automation-tools-design-spec.md` の関連リンク節を DQ-002 準拠へ更新する。
- Wave A の削減結果を task docs と検証ログで確認する。

### 3.2 Out of Scope (必須)

- Wave B/C 対象 docs の修正。
- DQ-001/003/004 の修正。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001:
  - `docs/specs/automation-tools-design-spec.md` の DQ-002 warning を 12 件から 0 件にする。
- AC-002:
  - `-AllTasks -DocQualityMode warning -OutputFormat json` の `dq002_count` を 21 から 9 へ減少させる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `docs/specs/automation-tools-design-spec.md`
- **検証項目**: DQ-002 判定条件（docs/work 両導線）が満たされる
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning` が PASS

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: 全タスク一括チェック
- **検証項目**: Wave A 適用後の `dq002_count` 減少
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json` で `dq002_count=9`

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: task state と docs index 整合
- **検証項目**: task docs 更新による副作用がない
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning` が PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `docs/specs/automation-tools-design-spec.md` の関連リンクを目視確認
  2. `-AllTasks` の出力から Wave A 対象 warning が消えていることを確認
- **期待される結果**:
  - AC-001 と AC-002 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/*`
- 影響する仕様:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
- 非機能影響:
  - doc quality warning の可視性と運用再現性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約:
  - Wave A では対象 1 ファイルのみを修正する
- 想定リスク:
  - 追加リンクの粒度不足で DQ-002 が残る
- 回避策:
  - `-AllTasks` で件数差分を必ず検証する

## 8. 未確定事項 (Open Issues) (必須)

- なし（対象ファイルと削減目標は確定済み）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/request.md`
- investigation: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/investigation.md`
- plan: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/plan.md`
- review: `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/review.md`
- docs:
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `docs/operations/high-priority-backlog.md`
