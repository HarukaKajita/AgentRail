# 仕様書: 2026-02-20__fix-wave3-investigation-broken-tmp-reference

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/request.md`
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/investigation.md`
- 理解ポイント:
  - 本タスクは DQ-002 とは別の `link_targets_exist` FAIL を解消する是正タスク。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__fix-wave3-investigation-broken-tmp-reference
- タイトル: Wave3 Investigation 一時参照切れ修正
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: task12 investigation の一時パス記述が checker fail を引き起こす。
- 目的: checker fail を解消し、同種記述の再発防止ルールを整備する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- task12 investigation の該当記述修正。
- 再発防止の記述ルール追記。

### 3.2 Out of Scope (必須)

- DQ-002 warning 21件の修正。
- KPI 算出ロジックの変更。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: task12 investigation の参照切れ要因を除去できる。
- AC-002: `-AllTasks -DocQualityMode warning` で DQ-002 以外の fail が発生しない。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
- **検証項目**: 一時パス依存の参照表現が残っていない。
- **合格基準**: 対象ファイルの記述が恒久参照へ置換されている。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: consistency-check 全体実行。
- **検証項目**: rule `link_targets_exist` で task12 fail が再発しない。
- **合格基準**: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` が DQ-002 warning のみで PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: task12 単体検証。
- **検証項目**: state/consistency の task12 結果が保持される。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. task12 investigation の記述を目視で確認する。
  2. checker 出力で fail が消えていることを確認する。
- **期待される結果**: AC-001 と AC-002 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`（必要時）
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/*`
- 影響する仕様:
  - `docs/operations/human-centric-doc-bank-governance.md`
- 非機能影響:
  - docs 品質チェックの安定性が向上する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: checker 仕様変更は行わず、資料修正で解決する。
- 想定リスク: 修正対象の見落としで fail が再発する。
- 回避策: `-AllTasks` と task12 単体の両方で検証する。

## 8. 未確定事項 (Open Issues) (必須)

- 横断的な一時参照記述の追加スキャン範囲。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/request.md`
- investigation: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/investigation.md`
- plan: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/plan.md`
- review: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
