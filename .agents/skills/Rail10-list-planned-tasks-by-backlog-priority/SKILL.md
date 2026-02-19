---
name: Rail10:list-planned-tasks-by-backlog-priority
description: docs/operations/high-priority-backlog.md と work/*/state.json を照合し、planned タスクを依存関係込みで優先表示する。`plan-draft` / `plan-ready` / `dependency-blocked` を示したうえで提案3案と確認質問2-4件で次の着手判断を支援する。
---

# List Planned Tasks By Backlog Priority

## 役割

バックログと実状態を照合し、`plan-draft`・`plan-ready`・`dependency-blocked` を可視化して着手判断を支援する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `docs/operations/high-priority-backlog.md`
- `work/*/state.json`

## 実行手順

1. 付属スクリプトで planned タスクの依存解決済み優先一覧を取得する。
2. `depends_on` と backlog の依存記述が一致しているか warnings を確認する。
3. `Ready Tasks (plan-ready)` と `Blocked Tasks (dependency-blocked)` を要約し、次に着手可能な task-id を明確化する。
4. 次の進め方を提案オプション3案で示す。
5. 推奨案を1つ選び理由を示す。
6. 必要なら確認質問を 2〜4 件提示する。
7. 次タスク着手前に、直前タスクの境界コミット完了を確認する。

## コマンド

```powershell
pwsh -NoProfile -File ".agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1" -RepoRoot .
```

スキルディレクトリ直下（`.agents/skills/Rail10-list-planned-tasks-by-backlog-priority`）から実行する場合:

```powershell
pwsh -NoProfile -File "./scripts/list_planned_tasks.ps1" -RepoRoot "../../.."
```

## 出力フォーマット

1. Planned Tasks (Priority Order)
2. Ready Tasks (plan-ready)
3. Blocked Tasks (dependency-blocked)
4. Warnings
5. 提案オプション（3案）
6. 推奨案
7. 確認質問（2〜4件）

## 禁止事項

- backlog と work の不整合を無視しない。
- 依存未解決 task を ready 扱いで推奨しない。
- 一覧表示だけで意思決定支援を省略しない。
- 根拠なしで優先度を変更しない。
- 境界コミット未完了のまま次タスク着手を推奨しない。

