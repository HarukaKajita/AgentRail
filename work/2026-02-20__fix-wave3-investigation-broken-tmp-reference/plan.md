# Plan: 2026-02-20__fix-wave3-investigation-broken-tmp-reference

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`
- 理解ポイント:
  - 本タスクは依存なしのため、plan-ready から plan-final を確定して実施する。

## 1. 対象仕様

- `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的:
  - task12 investigation の参照切れを解消し、再発防止ルールを確定する。
- 実施項目:
  1. task12 investigation の該当記述を恒久参照表現へ修正する。
  2. 必要に応じて運用 docs の記述ルールを補足する。
  3. task12 単体 + 全体 checker を再実行して結果を確認する。
- 成果物:
  - 修正済み investigation
  - 検証ログ（checker PASS）

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`。
- 判定結果: pass（起票時点）

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md` の固定 `.tmp` 参照を実行引数ベースの記述へ置換する。
  2. `docs/operations/wave3-kpi-process-findings-loop.md` のサンプルパスを `<report-json-path>` / `<report-markdown-path>` に置換し、再発防止ルールを追加する。
  3. task2 の計画・レビュー・状態ファイルを実績化し、backlog と MEMORY を次タスク着手状態へ同期する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - fail が残る場合は `.tmp` 固定参照へ戻さず、既存 checker 仕様を優先して参照表現を再設計する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001 と AC-002 が review で PASS。
- `state.json` は `done`。
- backlog の次着手候補が `2026-02-20__define-kpi-report-execution-calendar` へ遷移している。
