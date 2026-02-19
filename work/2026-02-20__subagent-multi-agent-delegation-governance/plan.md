# Plan: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`
- 理解ポイント:
  - 委譲範囲は request / investigation / spec のみで、plan 以降は親固定。

## 1. 対象仕様

- `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`

## 2. Execution Commands

- task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__subagent-multi-agent-delegation-governance`
- all tasks consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- state validate:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- planned task list:
  - `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`

## 3. 実施ステップ

1. `request / investigation / spec` を同一 `delegated_agent_id` で処理する実行契約を定義する。
2. 委譲必須コンテキストと一次成果物更新先（3ファイル）を定義する。
3. sidecar 監査ログ規約と親返却フォーマットを定義する。
4. 親再検討ゲート（`gate_result`）を定義し、`pass` 前の `plan` 着手禁止とコミット禁止を明記する。
5. 親固定工程（`plan / test / review / docs_update / commit`）を明記する。
6. checker 実行と `review.md` 更新で AC 完了判定を行う。

## 4. 変更対象ファイル

- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `AGENTS.md`（必要時）
- `.agents/skills/**/SKILL.md`（実装段階）
- `agents/skills/**/SKILL.md`（実装段階）
- `work/2026-02-20__subagent-multi-agent-delegation-governance/*`

## 5. リスクとロールバック

- リスク:
  - 単一委譲エージェントがボトルネックになる。
  - 委譲した3工程に同系統の誤りが連鎖する。
- ロールバック:
  1. `request / investigation / spec` を親主導に戻し、委譲を停止する。
  2. 一時的に `request` のみ委譲して段階再導入する。

## 6. 完了判定

- AC-001〜AC-008 が `review.md` で PASS になる。
- `tools/consistency-check/check.ps1 -AllTasks` が PASS する。
- `tools/state-validate/validate.ps1 -AllTasks` が PASS する。
