# Review: 2026-02-19__rail10-skill-command-path-fix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/plan.md`
- 理解ポイント:
  - Rail10 スキルのコマンド案内が、スキル同梱 script を直接実行する形へ統一されていることを確認する。

## 1. レビュー対象

- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`

## 2. 受入条件評価

- AC-001: PASS（legacy $HOME/.agents 案内を除去）
- AC-002: PASS（スキル同梱 `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` 実行案内へ統一）
- AC-003: PASS（記載コマンドの実行で planned task 一覧を取得）
- AC-004: PASS（`.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` の内容一致を確認）
- AC-005: PASS（review/state/backlog/memory を完了状態へ更新）

## 3. テスト結果

### Unit Test

- 実施内容:
  - rg -n '\$HOME/\.agents' .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md
  - `rg -n '\.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks\.ps1' .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- 結果: PASS（前者0件、後者2件）

### Integration Test

- 実施内容:
  - `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`
  - `pwsh -NoProfile -File ./scripts/list_planned_tasks.ps1 -RepoRoot ../../..`（workdir: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority`）
- 結果: PASS

### Regression Test

- 実施内容:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__rail10-skill-command-path-fix`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンドセクションから legacy $HOME/.agents 表記が消えていることを確認。
  2. リポジトリ起点とスキルディレクトリ起点の両コマンドで同一出力形式を確認。
  3. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` を diff 比較して一致を確認。
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - 他スキルでも legacy $HOME/.agents 表記の有無を定期チェックする仕組みを追加すると再発防止になる。

## 5. 結論

- Rail10 のコマンド案内をスキル同梱 script 実行へ統一し、受入条件を満たした。
- 本タスクは `done` 判定で問題ない。

## 6. Process Findings

### 6.1 Finding F-001

- finding_id: F-001
- category: docs
- severity: low
- summary: Rail10 のコマンド案内をスキル同梱 script 基準に統一できた。
- evidence: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` から legacy $HOME/.agents が除去され、2系統の実行コマンドが PASS した。
- action_required: no
- linked_task_id: none
