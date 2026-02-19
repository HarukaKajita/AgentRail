# Plan: 2026-02-19__task-dependency-aware-prioritization-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 0. 着手前確定

### 0.1 実装戦略オプション（3案）

1. 速度重視:
   - Rail10 表示だけ先行対応し、起票/着手ゲートは後続に回す。
2. バランス:
   - state モデル + 着手ゲート + Rail10 表示を同時実装し、起票改善は次段へ分離する。
3. 拡張重視（採用）:
   - 起票時依存調査、着手時依存ゲート、backlog/Rail10 表示、検証ルールを一体実装する。

### 0.2 推奨案

- 採用: オプション3（拡張重視）
- 理由:
  - ユーザー要望が「起票」「着手」「表示」を一貫して求めているため。
  - 中途段階で運用を分断すると、依存情報の記載漏れが残るため。

### 0.3 確認質問（2〜4件）

- なし。

### 0.4 blocked 判定

- blocked ではない。

## 1. 対象仕様

- `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md`

## 2. Execution Commands

- target task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-dependency-aware-prioritization-flow`
- all task state validation:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- all task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- dependency-aware listing check:
  - `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`

## 3. 実施ステップ

1. 依存関係データモデルを state/backlog へ定義する。
2. 起票時依存調査と依存不足時追加起票ルールを実装する。
3. 着手時依存ゲートと優先タスク切替ルールを実装する。
4. Rail10 スキルとスクリプトに依存表示と優先判定を追加する。
5. validator/checker に依存関係検証を追加する。
6. docs/workflow を更新し、review/state で完了判定を記録する。

## 4. 変更対象ファイル

- `tools/state-validate/validate.ps1`
- `tools/consistency-check/check.ps1`
- `tools/improvement-harvest/create-task.ps1`
- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `work/*/state.json`
- `work/2026-02-19__task-dependency-aware-prioritization-flow/review.md`
- `work/2026-02-19__task-dependency-aware-prioritization-flow/state.json`

## 5. リスクとロールバック

- リスク:
  - 既存 task の移行が追いつかず、検証失敗が多発する。
  - 依存循環で planned キューが停滞する。
- ロールバック:
  1. 依存検証ルールを警告モードへ一時切替する。
  2. backlog 表示のみ先行反映し、着手ゲートを feature flag で無効化する。
  3. 依存情報未整備 task を対象外とする移行期間を設定する。

## 6. テスト実行順

1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-dependency-aware-prioritization-flow`
2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
4. `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`

## 7. 完了判定

- AC-001〜AC-006 が `work/2026-02-19__task-dependency-aware-prioritization-flow/review.md` で PASS 判定になる。
- 依存表示付き backlog/Rail10 出力が確認できる。
