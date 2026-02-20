# Plan: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`
- 理解ポイント:
  - 起票段階では plan-draft まで確定し、実装時に plan-final を更新する。

## 1. 対象仕様

- `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`

## 2. plan-draft

- 目的:
  - Wave A 対象ファイルの DQ-002 warning 12 件を 0 件にする。
- 実施項目:
  1. `docs/specs/automation-tools-design-spec.md` の関連リンク節を修正する。
  2. 修正後の `dq002_count` を全体で再集計する。
  3. backlog と MEMORY を Wave B 着手可能な状態へ同期する。
- 成果物:
  - 修正済み docs
  - 検証結果（Wave A: 12 -> 0、全体: 21 -> 9）

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`
- 判定結果: pass（起票時点）

## 4. plan-final

- 実装順序:
  - 起票段階のため未確定。実装着手時に詳細化する。
- 検証順序:
  - 起票段階のため未確定。実装着手時に詳細化する。
- ロールバック:
  - 変更差分を戻してリンク配置を再設計する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照している
- `state.json` が `planned` かつ `depends_on=[]` である
- backlog で Wave A が `plan-ready` として登録される
