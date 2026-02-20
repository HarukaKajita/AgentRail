# Plan: 2026-02-20__define-kpi-report-execution-calendar

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`
- 理解ポイント:
  - kickoff 段階では plan-draft を確定し、実装順序の確定は gate 後に行う。

## 1. 対象仕様

- `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`

## 2. plan-draft

- 目的:
  - KPI レポート実行タイミングを運用カレンダーとして確定する。
- 実施項目:
  1. 週次/リリース前/臨時の実行条件を定義する。
  2. 実行担当、レビュー反映先、エスカレーションを定義する。
  3. 既存 wave3 docs からの参照導線を計画する。
- 成果物:
  - KPI 実行カレンダー定義
  - wave3 docs 導線更新案

## 3. depends_on gate

- 依存: `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
- 判定方針: 依存 task が done なら `plan-ready`。
- 判定結果: pass（依存解決済み）

## 4. plan-final

- 実装順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- 検証順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- ロールバック:
  - 記述粒度不足の場合は runbook を分割して再設計する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__define-kpi-report-execution-calendar -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照し、depends_on gate の前提が明記される。
- backlog/state に planned 情報が反映される。
- kickoff 境界コミットの scope check が PASS。
