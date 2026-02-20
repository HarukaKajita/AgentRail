# Plan: 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
- 理解ポイント:
  - runbook は CI 実装の順序と一致しなければ復旧速度が低下する。

## 1. 対象仕様

- `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`

## 2. plan-draft

- 目的: CI 運用 docs を warning/fail 二段ゲートへ同期する。
- 実施項目:
  1. runbook を CI 実行順序に合わせて再構成
  2. 実装ガイドのチェック手順を state-validate 併用へ更新
  3. backlog/state/MEMORY を Wave 3 着手状態へ同期
- 成果物:
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - task 文書一式

## 3. depends_on gate

- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`
- 判定方針: 依存 task が done の場合のみ runbook 整合を実施する。
- 判定結果: pass（`2026-02-20__wave2-enforce-doc-quality-fail-mode[done]`）

## 4. plan-final

- 実行フェーズ:
  1. docs 更新: runbook + 実装ガイドの整合更新
  2. task 更新: request/investigation/spec/plan/review/state を確定
  3. 検証: unit/integration/regression/manual を実行
  4. 同期: backlog/MEMORY を Wave 3 着手状態へ反映
- 検証順序:
  1. `rg -n "DocQualityMode|state-validate|consistency-check" docs/operations/ci-failure-runbook.md`
  2. `rg -n "state-validate|consistency-check" docs/operations/framework-request-to-commit-visual-guide.md`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-enforce-doc-quality-fail-mode,2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
  5. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  7. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  8. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - 運用混乱が発生した場合は runbook 変更を巻き戻し、`docs/operations/wave2-doc-quality-fail-mode.md` を正本として暫定運用する。

## 5. Execution Commands

- `rg -n "DocQualityMode|state-validate|consistency-check" docs/operations/ci-failure-runbook.md`
- `rg -n "state-validate|consistency-check" docs/operations/framework-request-to-commit-visual-guide.md`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-enforce-doc-quality-fail-mode,2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-004 が review で PASS。
- `state.json` は done、`high-priority-backlog` で Wave 3 KPI task が plan-ready になる。
- `MEMORY.md` の次アクションが Wave 3 着手へ更新される。
