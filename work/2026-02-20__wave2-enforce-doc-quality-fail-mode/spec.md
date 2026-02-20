# 仕様書: 2026-02-20__wave2-enforce-doc-quality-fail-mode

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/request.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/investigation.md`
- 理解ポイント:
  - warning 段階の観測結果を前提に、運用経路で fail 強制へ昇格する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave2-enforce-doc-quality-fail-mode
- タイトル: Wave 2: docs品質チェック fail 昇格
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: warning mode は導入済みだが、CI の変更対象 task 経路で fail 強制が未適用。
- 目的: docs品質 issue を CI fail として扱う運用へ昇格し、rollback 手順を確立する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `.github/workflows/ci-framework.yml` の対象 task 検証を `DocQualityMode=fail` へ切替える。
- fail mode 運用ガイドを docs 化する。
- task 資料、backlog、MEMORY を昇格状態へ同期する。

### 3.2 Out of Scope [空欄禁止]

- warning 21 件の全解消。
- CI runbook 本文の全面改訂（次タスクで実施）。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `.github/workflows/ci-framework.yml` で変更対象 task の `state-validate` / `consistency-check` が `DocQualityMode=fail` で実行される。
- AC-002: `tools/consistency-check/check.ps1` と `tools/state-validate/validate.ps1` の fail mode が docs品質 issue を FAIL として返すことを確認できる。
- AC-003: `docs/operations/wave2-doc-quality-fail-mode.md` に適用条件・rollback・残課題（warning 21件）が記録される。
- AC-004: backlog/state/MEMORY が次タスク `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates` 着手状態へ同期される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `.github/workflows/ci-framework.yml`
- 観点: fail mode 指定が対象 task 経路へ組み込まれている。
- 合格条件: workflow 内で次が確認できる。
  - `tools/state-validate/validate.ps1 -TaskId $taskId -DocQualityMode fail`
  - `tools/consistency-check/check.ps1 -TaskId $taskId -DocQualityMode fail`

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: fail mode 実行可能性（依存 task + 本 task）。
- 観点: warning 段階で導入した mode が fail 昇格で正常に動作する。
- 合格条件:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-implement-doc-quality-warning-mode,2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail` が PASS。
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail` が PASS。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全体チェック運用。
- 観点: `-AllTasks` は warning 維持で既存運用を壊さない。
- 合格条件:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `2026-02-18__framework-pilot-01` を fail mode で実行し、DQ-002 で FAIL することを確認する。
  2. 本 task 自体を fail mode で実行し、PASS することを確認する。
  3. backlog で本 task を done、次 task を plan-ready として確認する。
- 期待結果: fail mode の強制と段階運用の両立を確認できる。

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `.github/workflows/ci-framework.yml`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/*`
  - `MEMORY.md`
- 影響する仕様:
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
- 非機能影響:
  - docs品質問題の検知タイミングが PR 時点へ前倒しされる。

## 7. 制約とリスク [空欄禁止]

- 制約: `-AllTasks` を fail 化すると既存 warning で運用停止するため、段階適用を維持する。
- 想定リスク:
  - fail mode 強制で既存 task が想定外に落ちる。
  - rollback 手順が未整備だと緊急復旧が遅延する。
- 回避策:
  - CI は対象 task のみ fail、全体は warning の二段運用を明文化する。

## 8. 未確定事項 [空欄禁止]

- warning 21 件の解消期限と KPI 連動閾値（Wave 3 で確定）。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/request.md`
- investigation: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/investigation.md`
- plan: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/plan.md`
- review: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/review.md`
- docs:
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `docs/operations/high-priority-backlog.md`
