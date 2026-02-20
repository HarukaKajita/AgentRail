# Plan: 2026-02-20__run-wave3-doc-operations-review

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__run-wave3-doc-operations-review/spec.md`
- 理解ポイント:
  - kickoff 段階では plan-draft を定義し、depends_on 未解決時は gate を blocked とする。

## 1. 対象仕様

- `work/2026-02-20__run-wave3-doc-operations-review/spec.md`

## 2. plan-draft

- 目的:
  - wave3 docs 3資料の運用レビュー観点と記録形式を確定する。
- 実施項目:
  1. 3資料横断のチェックリスト（責務/タイミング/改善接続）を設計する。
  2. レビュー記録テンプレートを定義する。
  3. 改善起票条件と優先順位づけルールを定義する。
- 成果物:
  - レビュー観点チェックリスト
  - 記録テンプレート
  - follow-up 接続基準

## 3. depends_on gate

- 依存: `2026-02-20__define-kpi-report-execution-calendar`
- 判定方針: 依存 task が done なら `plan-ready`、未完了なら `dependency-blocked`。
- 判定結果: pending（起票時点）

## 4. plan-final

- 実装順序:
  - kickoff 段階のため未確定。depends_on gate pass 後に確定する。
- 検証順序:
  - kickoff 段階のため未確定。depends_on gate pass 後に確定する。
- ロールバック:
  - 観点不足が判明した場合はチェックリスト項目を増補して再計画する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照し、depends_on gate が定義されている。
- backlog/state の planned 情報が整合している。
- kickoff 境界コミットの scope check が PASS。
