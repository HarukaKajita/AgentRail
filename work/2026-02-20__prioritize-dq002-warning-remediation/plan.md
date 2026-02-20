# Plan: 2026-02-20__prioritize-dq002-warning-remediation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- 理解ポイント:
  - 本タスクは起票段階のため、plan-draft のみ確定し plan-final は未確定のまま維持する。

## 1. 対象仕様

- `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的:
  - DQ-002 warning 21件の解消優先順と分割起票方針を確定する。
- 実施項目:
  1. warning 発生対象を docs 種別と影響度で分類する。
  2. 優先度基準（高頻度参照 docs 優先）を決定する。
  3. 後続実装修正タスクの分割順を定義する。
- 成果物:
  - 優先度マトリクス
  - 分割起票方針
  - backlog 反映案

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`。
- 判定結果: pass（起票時点）

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. `-AllTasks -DocQualityMode warning -OutputFormat json` で DQ-002 発生分布を再集計する。
  2. `docs/operations/dq002-warning-remediation-priority-plan.md` を作成し、Wave A/B/C の優先順を定義する。
  3. `docs/operations/wave2-doc-quality-warning-mode.md` に優先順資料への導線を追記する。
  4. task1 の request/investigation/spec/plan/review/state を実績化する。
  5. backlog と MEMORY を次タスク着手状態へ同期する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - 優先度基準が不適切な場合は分類軸を再定義して plan-draft を改訂する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001 と AC-002 が review で PASS。
- `state.json` は `done`。
- backlog の次着手候補が `2026-02-20__fix-wave3-investigation-broken-tmp-reference` へ遷移している。
