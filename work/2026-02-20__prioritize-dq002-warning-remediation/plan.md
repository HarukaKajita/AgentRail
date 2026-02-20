# Plan: 2026-02-20__prioritize-dq002-warning-remediation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- 理解ポイント:
  - 本タスクは起票段階のため、plan-draft のみ確定し plan-final は未確定のまま維持する。

## 1. 対象仕様

- `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`

## 2. plan-draft

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

## 4. plan-final

- 実装順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- 検証順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- ロールバック:
  - 優先度基準が不適切な場合は分類軸を再定義して plan-draft を改訂する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__prioritize-dq002-warning-remediation -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照して確定している。
- backlog と state の planned 整合が取れている。
- 起票境界コミットの scope check が PASS。
