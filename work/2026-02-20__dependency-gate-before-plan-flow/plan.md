# Plan: 2026-02-20__dependency-gate-before-plan-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
  - `work/2026-02-20__dependency-gate-before-plan-flow/spec.md`
- 理解ポイント:
  - `plan-draft` は探索用、`plan-final` は gate pass 後の確定計画として分離する。

## 0. 着手前確定

### 0.1 実装戦略オプション（3案）

1. docs 先行:
   - docs のみ先に更新し、スクリプト変更は後続に分離する。
2. 判定先行:
   - checker/validator を先に更新し、docs を後追いで揃える。
3. 一括整合（採用）:
   - docs/skills/checker を同一実装単位で更新し、2段階計画フローを同時適用する。

### 0.2 推奨案

- 採用: オプション3（一括整合）
- 理由:
  - `plan-draft` / `plan-final` の意味が文書とロジックで一致しないと誤運用が起きるため。

### 0.3 確認質問（2〜4件）

- なし。

### 0.4 blocked 判定

- blocked ではない。

## 1. 対象仕様

- `work/2026-02-20__dependency-gate-before-plan-flow/spec.md`

## 2. Execution Commands

- target task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dependency-gate-before-plan-flow`
- all task state validation:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- all task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- planned task list:
  - `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`

## 3. 実施ステップ

1. 固定ワークフロー資料へ `plan-draft -> depends_on gate -> plan-final` の順序を定義する。
2. `plan-draft` の制約（探索用、確定判断に使わない）を docs/skills へ明記する。
3. gate 判定仕様（pass/fail）と fail 時の `dependency-blocked` 遷移を定義する。
4. gate pass 後のみ `plan-final` 確定可能にする判定ルールを checker/validator へ反映する。
5. backlog/Rail10 表示へ `plan-draft`, `plan-ready`, `dependency-blocked` を追加する。
6. review/state を更新して完了判定を記録する。

## 4. 変更対象ファイル

- `AGENTS.md`
- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `docs/operations/high-priority-backlog.md`
- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
- `tools/state-validate/validate.ps1`
- `tools/consistency-check/check.ps1`
- `work/2026-02-20__dependency-gate-before-plan-flow/review.md`
- `work/2026-02-20__dependency-gate-before-plan-flow/state.json`

## 5. リスクとロールバック

- リスク:
  - `plan-draft` と `plan-final` を混同し、誤って着手判断に使う可能性がある。
  - ステータス表示の更新漏れで運用が分岐する可能性がある。
- ロールバック:
  1. 表示を維持しつつ、2段階化を一時停止して 1段階 `plan` へ戻す。
  2. `plan-final` 強制を warning モードに落とし、移行期間を設ける。

## 6. テスト実行順

1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dependency-gate-before-plan-flow`
2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
5. `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`

## 7. 完了判定

- AC-001〜AC-008 が `work/2026-02-20__dependency-gate-before-plan-flow/review.md` で PASS 判定になる。
- 依存未解決時に `plan-final` へ進まないことが手動検証で確認できる。
