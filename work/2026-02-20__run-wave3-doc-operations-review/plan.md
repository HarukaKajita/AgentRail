# Plan: 2026-02-20__run-wave3-doc-operations-review

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__run-wave3-doc-operations-review/spec.md`
- 理解ポイント:
  - depends_on は解決済みのため、plan-ready で plan-final を確定して実運用レビューを完了させる。

## 1. 対象仕様

- `work/2026-02-20__run-wave3-doc-operations-review/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

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
- 判定結果: pass（依存 task は done）

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. `docs/operations/wave3-doc-operations-review.md` を新規作成し、レビュー周期・チェックリスト・記録テンプレートを定義する。
  2. wave3 関連 docs（thresholds/metrics/loop/calendar）へレビュー資料への導線を追加する。
  3. task4 の調査・仕様・計画・レビュー・状態ファイルを実績化し、backlog/MEMORY を最終完了状態へ更新する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- ロールバック:
  - 観点不足が判明した場合はチェックリスト項目を増補し、優先度表を改訂する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__run-wave3-doc-operations-review -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001 と AC-002 が review で PASS。
- `state.json` は `done`。
- backlog の planned タスクが 0 件である。
