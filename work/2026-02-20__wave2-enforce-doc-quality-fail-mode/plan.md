# Plan: 2026-02-20__wave2-enforce-doc-quality-fail-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
- 理解ポイント:
  - fail 昇格は CI の対象 task 経路から開始する。

## 1. 対象仕様

- `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: docs品質 issue を CI fail として扱う運用へ昇格する。
- 実施項目:
  1. CI workflow の対象 task 経路へ `DocQualityMode=fail` を適用
  2. fail mode 運用 docs と rollback 方針を追加
  3. backlog/state/MEMORY を次タスク着手状態へ同期
- 成果物:
  - `.github/workflows/ci-framework.yml`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - task 文書一式

## 3. depends_on gate

- 依存: `2026-02-20__wave2-implement-doc-quality-warning-mode`
- 判定方針: 依存 task が done の場合のみ fail 昇格へ進む。
- 判定結果: pass（`2026-02-20__wave2-implement-doc-quality-warning-mode[done]`）

## 4. 確定実装計画 (Plan Final)

- 実行フェーズ:
  1. 実装: CI で対象 task の `state-validate`/`consistency-check` に fail mode を指定
  2. 文書化: fail mode ガイドと task 文書更新
  3. 検証: fail/warning 両モードのテスト実行
  4. 同期: backlog/state/MEMORY 更新
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-implement-doc-quality-warning-mode,2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -DocQualityMode fail`（FAIL 期待）
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-18__framework-pilot-01 -DocQualityMode fail`（FAIL 期待）
  5. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  7. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - CI fail mode が過剰にブロックする場合は対象 step を warning 指定へ戻し、次タスクで runbook と閾値を再調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-implement-doc-quality-warning-mode,2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-enforce-doc-quality-fail-mode -DocQualityMode fail`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -DocQualityMode fail`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-18__framework-pilot-01 -DocQualityMode fail`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-004 が review で PASS。
- `state.json` は done、`high-priority-backlog` は本 task を Completed へ移動。
- `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates` が plan-ready で着手可能。
