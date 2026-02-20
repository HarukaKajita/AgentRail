# Plan: 2026-02-20__subagent-multi-agent-delegation-governance

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/investigation.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`
- 理解ポイント:
  - 委譲範囲は request / investigation / spec / plan-draft で、depends_on gate 以降は親固定。

## 1. 対象仕様

- `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

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

## 4. 確定実装計画 (Plan Final)

1. request / investigation / spec / plan-draft を同一 `delegated_agent_id` で処理する実行契約を定義する。
2. 委譲必須コンテキストと一次成果物更新先（4ファイル）を定義する。
3. sidecar 監査ログ規約と親返却フォーマットを定義する。
4. 親再検討ゲート（`gate_result`）を定義し、`pass` 前の kickoff / depends_on gate / plan-final 着手禁止とコミット禁止を明記する。
5. 親固定工程（`depends_on gate / plan-final / test / review / docs_update / commit`）を明記する。
6. AGENTS / 運用 docs / skill ファイルを更新し、委譲契約を実運用へ反映する。
7. checker 実行と `review.md` 更新で AC 完了判定を行う。

## 4. 変更対象ファイル

- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `AGENTS.md`（必要時）
- `.agents/skills/Rail1-write-request/SKILL.md`
- `.agents/skills/Rail3-write-investigation/SKILL.md`
- `.agents/skills/Rail5-write-spec/SKILL.md`
- `.agents/skills/Rail6-write-plan/SKILL.md`
- `agents/skills/Rail1-write-request/SKILL.md`
- `agents/skills/Rail3-write-investigation/SKILL.md`
- `agents/skills/Rail5-write-spec/SKILL.md`
- `agents/skills/Rail6-write-plan/SKILL.md`
- `work/2026-02-20__subagent-multi-agent-delegation-governance/*`

## 5. リスクとロールバック

- リスク:
  - 単一委譲エージェントがボトルネックになる。
  - 委譲した4工程に同系統の誤りが連鎖する。
- ロールバック:
  1. request / investigation / spec / plan-draft を親主導に戻し、委譲を停止する。
  2. 一時的に `request` のみ委譲して段階再導入する。

## 6. 完了判定

- AC-001〜AC-008 が `review.md` で PASS になる。
- `tools/consistency-check/check.ps1 -AllTasks` が PASS する。
- `tools/state-validate/validate.ps1 -AllTasks` が PASS する。
