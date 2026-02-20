# 仕様書: 2026-02-20__prioritize-dq002-warning-remediation

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/investigation.md`
- 理解ポイント:
  - 本タスクは DQ-002 warning 解消タスク群の優先順と分割方針を決める起票タスク。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__prioritize-dq002-warning-remediation
- タイトル: DQ-002 Warning 解消優先順策定
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: DQ-002 warning が 21件継続しているが、解消順序の標準が未定義。
- 目的: 影響度に基づく優先順位と分割起票ルールを確定する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- DQ-002 warning 対象の分類方針策定。
- 優先度基準と分割起票順の定義。
- 後続 task 起票に必要な運用ルール明文化。

### 3.2 Out of Scope (必須)

- DQ-002 warning 個別修正の実装。
- DQ-002 以外のルール是正。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: DQ-002 warning 21件を優先度基準付きで分類できる。
- AC-002: 分割起票順と依存方針を `docs/operations/dq002-warning-remediation-priority-plan.md` と docs/work に記録できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- **検証項目**: AC と分類基準が一貫している。
- **合格基準**: spec 空欄禁止項目が埋まり、AC-001/AC-002 に矛盾がない。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `docs/operations/high-priority-backlog.md` と `state.json`
- **検証項目**: planned task 表記と依存定義が一致する。
- **合格基準**: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning` が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の task 運用整合。
- **検証項目**: 新規起票で既存 done task の整合を壊さない。
- **合格基準**: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning` が PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. backlog に planned task が追加されていることを確認。
  2. request/investigation/spec/plan/review/state の6ファイルが存在することを確認。
- **期待される結果**: AC-001 と AC-002 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/*`
- 影響する仕様:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
- 非機能影響:
  - DQ-002 warning 解消の実行順が明確になり、運用再現性が向上する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 本タスクでは実装修正を行わず、優先順と分割方針のみ定義する。
- 想定リスク: 分割粒度が粗すぎると後続 task の工数見積りが崩れる。
- 回避策: 依存と検証単位を spec/plan で明示する。

## 8. 未確定事項 (Open Issues) (必須)

- 実修正タスクの個数と命名規則。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__prioritize-dq002-warning-remediation/request.md`
- investigation: `work/2026-02-20__prioritize-dq002-warning-remediation/investigation.md`
- plan: `work/2026-02-20__prioritize-dq002-warning-remediation/plan.md`
- review: `work/2026-02-20__prioritize-dq002-warning-remediation/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
