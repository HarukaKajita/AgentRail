# 仕様書: 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `.github/workflows/ci-framework.yml`
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/request.md`
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/investigation.md`
- 理解ポイント:
  - runbook と実装ガイドを CI の現行ゲート（warning/fail）へ同期するタスクである。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates
- タイトル: Wave 2: CI runbook と docs品質ゲート整合
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: fail mode 導入後、運用 docs が CI 実装の実行順序に追従できていなかった。
- 目的: CI 失敗時の復旧手順を docs品質ゲート仕様へ整合させる。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/operations/ci-failure-runbook.md` を warning/fail 二段ゲート手順へ更新する。
- `docs/operations/framework-request-to-commit-visual-guide.md` のチェック項目を state-validate 併用へ更新する。
- task 資料、backlog、MEMORY を Wave 3 着手状態へ同期する。

### 3.2 Out of Scope (必須)

- warning 21 件の個別修正。
- Wave 3 KPI 実装。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `docs/operations/ci-failure-runbook.md` が CI 実装順序（all/warning -> task/fail）に一致する。
- AC-002: runbook に target task fail mode（`state-validate -TaskId <task-id> -DocQualityMode fail` / `consistency-check -TaskId <task-id> -DocQualityMode fail`）の失敗時対処が追加される。
- AC-003: `docs/operations/framework-request-to-commit-visual-guide.md` が state-validate + consistency-check 運用を明示する。
- AC-004: backlog/state/MEMORY が次タスク `2026-02-20__wave3-define-doc-quality-kpi-thresholds` 着手状態へ同期される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `docs/operations/ci-failure-runbook.md`, `docs/operations/framework-request-to-commit-visual-guide.md`
- **検証項目**: `DocQualityMode warning/fail` の運用手順が文書化されている。
- **合格基準**:
  - `rg -n "DocQualityMode|state-validate|consistency-check" docs/operations/ci-failure-runbook.md`
  - `rg -n "state-validate|consistency-check" docs/operations/framework-request-to-commit-visual-guide.md`

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `wave2-enforce` と本 task の依存接続。
- **検証項目**: fail mode 導入結果が runbook へ反映されている。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-enforce-doc-quality-fail-mode,2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning` が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全体検証運用。
- **検証項目**: docs 更新後も validator 運用が破綻しない。
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. runbook に「all/warning」「task/fail」の両方が記載されていることを確認する。
  2. `high-priority-backlog` で本 task が done、Wave 3 task が plan-ready へ遷移していることを確認する。
  3. `MEMORY.md` の次アクションが Wave 3 に更新されていることを確認する。
- **期待される結果**: AC-001〜AC-004 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/*`
  - `MEMORY.md`
- 影響する仕様:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
- 非機能影響:
  - CI 障害時の復旧判断が文書だけで実行可能になる。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: docs 更新のみで CI 実装そのものは追加変更しない。
- 想定リスク:
  - runbook と CI 実装の再乖離。
  - warning 21 件の扱いが不明確になる。
- 回避策:
  - runbook に現行 step 順序と rollback を明記し、Wave 3 task へ引き継ぐ。

## 8. 未確定事項 (Open Issues) (必須)

- warning 21 件の優先解消順と KPI 閾値（Wave 3 で確定）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/request.md`
- investigation: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/investigation.md`
- plan: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/plan.md`
- review: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/review.md`
- docs:
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/high-priority-backlog.md`
