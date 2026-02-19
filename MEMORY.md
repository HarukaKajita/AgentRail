# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__rail10-skill-command-path-fix
- タイトル: Rail10 Skill Command Path Fix
- 状態: planned
- 最終更新日時: 2026-02-19T19:19:04+09:00
- 担当: codex

## 2. 今回の目的

- `Rail10:list-planned-tasks-by-backlog-priority` のコマンド案内を、スキル同梱 `scripts/` 実行へ統一するタスクを起票する。
- 実装前に受入条件・テスト要件・docs 更新範囲を `spec.md` まで確定する。
- 起票完了後に差分をコミットする。

## 3. 完了済み

- `work/2026-02-19__rail10-skill-command-path-fix/` を作成し、必須6ファイル（request/investigation/spec/plan/review/state）を作成した。
- `investigation.md` で `SKILL.md` の `$HOME/.agents/...` と `agents/skills/...` の混在を確認した。
- `spec.md` で AC-001〜AC-005 とテスト要件（Unit/Integration/Regression/Manual）を確定した。
- `docs/operations/high-priority-backlog.md` に本タスクを `planned` の優先タスクとして追加した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: Rail10 スキルの実行案内は `$HOME` 依存を排除し、スキル同梱 `scripts/list_planned_tasks.ps1` を正本導線にする。
- 決定内容: `.agents/skills/...` と `agents/skills/...` が併存する場合、`SKILL.md` は同内容を維持する。
- 根拠資料:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
  - `work/2026-02-19__rail10-skill-command-path-fix/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `Rail10` スキルの `SKILL.md` コマンドセクションを `scripts/` 起点へ実装修正する。
2. 記載コマンドの実行確認を行い、`review.md` に結果を記録する。
3. `state.json` を `done` に更新する。

## 7. 参照先

- `work/2026-02-19__rail10-skill-command-path-fix/request.md`
- `work/2026-02-19__rail10-skill-command-path-fix/investigation.md`
- `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
- `work/2026-02-19__rail10-skill-command-path-fix/plan.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
