# Plan: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`
- 理解ポイント:
  - `spec.md` の委譲マトリクスと品質ゲートを実装計画へ変換する。

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

1. 委譲対象工程と例外工程のマトリクスを docs へ反映する。
2. subagent 依頼コンテキストと返却フォーマットを各スキルへ反映する。
3. 工程 md の Subagent Worklog 記録テンプレートを標準化する。
4. 親側品質ゲート（再検証・差し戻し）を運用資料へ反映する。
5. checker 実行とレビュー更新で完了判定する。

## 4. 変更対象ファイル

- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `AGENTS.md`（必要時）
- `.agents/skills/**/SKILL.md`（実装段階）
- `agents/skills/**/SKILL.md`（実装段階）
- `work/2026-02-20__subagent-multi-agent-delegation-governance/*`

## 5. リスクとロールバック

- リスク:
  - 委譲規則が過剰で運用コストが増加する。
  - 例外工程定義が不十分で品質事故が発生する。
- ロールバック:
  1. 例外工程を増やして親固定範囲を一時拡大する。
  2. 適用対象スキルを段階導入に戻す。

## 6. 完了判定

- AC-001〜AC-006 が `review.md` で PASS になる。
- `tools/consistency-check/check.ps1 -AllTasks` が PASS する。
- `tools/state-validate/validate.ps1 -AllTasks` が PASS する。
