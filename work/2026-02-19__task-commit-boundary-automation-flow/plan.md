# Plan: 2026-02-19__task-commit-boundary-automation-flow

## 0. 着手前確定

### 0.1 実装戦略オプション（3案）

1. 速度重視:
   - docs ルールのみ更新し、検知実装は後続に分離する。
2. バランス:
   - docs ルール + commit前混在検知を導入し、段階適用する。
3. 拡張重視（採用）:
   - コミット境界定義、混在検知、skills/workflow/checker更新を同一タスクで実施する。

### 0.2 推奨案

- 採用: オプション3（拡張重視）
- 理由:
  - 要望が「自動で区切る」ため、境界定義と検知導入を分離しない方が効果が高いため。
  - docs と実検知の乖離を防ぎ、運用定着を加速できるため。

### 0.3 確認質問（2〜4件）

- なし。

### 0.4 blocked 判定

- blocked ではない。

## 1. 対象仕様

- `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`

## 2. Execution Commands

- target task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-commit-boundary-automation-flow`
- all tasks consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- all tasks state validate:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- staged diff inspection:
  - `git status --short`
  - `git diff --cached --name-only`

## 3. 実施ステップ

1. コミット境界タイミングと命名規則を定義する。
2. 単一task差分制約と例外規則を定義する。
3. 混在検知ロジックと運用導線（docs/skills）を実装する。
4. 段階移行ルール（fail-open/fail-close）を決定する。
5. review/state で結果を記録し、境界単位コミットで完了させる。

## 4. 変更対象ファイル

- `AGENTS.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `docs/operations/skills-framework-flow-guide.md`
- `tools/consistency-check/check.ps1`
- `tools/state-validate/validate.ps1`
- `tools/improvement-harvest/create-task.ps1`
- `.agents/skills/*/SKILL.md`（必要対象）
- `work/2026-02-19__task-commit-boundary-automation-flow/review.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/state.json`

## 5. リスクとロールバック

- リスク:
  - 境界判定が厳しすぎると作業速度が低下する。
  - 例外定義不足で運用停止が発生する。
- ロールバック:
  1. 混在検知を警告モードへ切り替える。
  2. docs ルールのみ維持し、厳格検証は次リリースへ延期する。
  3. 対象スキルを限定適用して段階導入する。

## 6. テスト実行順

1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-commit-boundary-automation-flow`
2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
4. `git status --short` / `git diff --cached --name-only` で境界コミット前の混在確認

## 7. 完了判定

- AC-001〜AC-006 が `work/2026-02-19__task-commit-boundary-automation-flow/review.md` で PASS 判定になる。
- 境界コミット運用が docs と検証ルールの両方で有効化される。
