# Plan: 2026-02-20__dq002-wave-c-fix-remaining-doc-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`
- 理解ポイント:
  - Wave C は depends_on 解決後に実施する最終バッチ。

## 1. 対象仕様

- `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`

## 2. plan-draft

- 目的:
  - 残存 6 件を解消し、全体 `dq002_count=0` を達成する。
- 実施項目:
  1. Wave C 対象 6 ファイルの関連リンクを補完する。
  2. 全体集計で DQ-002 ゼロ化を確認する。
  3. backlog と MEMORY を DQ-002 remediation 完了状態へ同期する。
- 成果物:
  - 修正済み Wave C 対象 docs
  - 検証結果（Wave C: 6 -> 0、全体: 6 -> 0）

## 3. depends_on gate

- 依存: `2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links`
- 判定方針: 依存 task が done なら `plan-ready`、未完了なら `dependency-blocked`
- 判定結果: pending（起票時点）

## 4. plan-final

- 実装順序:
  - 起票段階のため未確定。depends_on 解決後に更新する。
- 検証順序:
  - 起票段階のため未確定。depends_on 解決後に更新する。
- ロールバック:
  - 問題箇所のみ段階的に戻し、残件を再集計する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照している
- `state.json` に Wave B への depends_on が定義されている
- backlog で Wave C が `dependency-blocked` として登録される
