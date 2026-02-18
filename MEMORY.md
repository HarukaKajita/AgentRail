# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__consistency-check-all-tasks-exclusion-rules
- タイトル: Consistency Check All Tasks Exclusion Rules
- 状態: done
- 最終更新日時: 2026-02-19T01:59:58+09:00
- 担当: Codex

## 2. 今回の目的

- `-AllTasks` 実行時の archive/legacy 除外条件を実装する。
- 除外ルールを docs へ明文化する。
- task 成果物・バックログ状態・レビュー結果を整合させる。

## 3. 完了済み

- `tools/consistency-check/check.ps1` の `-AllTasks` に `archive`/`legacy` prefix 除外を追加した。
- `docs/specs/phase2-automation-spec.md` に `-AllTasks` 除外条件（`^(archive|legacy)(-|$)`）を追記した。
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/{investigation,spec,plan,review,state.json}` を更新した。
- `docs/operations/high-priority-backlog.md` で本タスクを Completed へ移動した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: `-AllTasks` は `work/` 直下のうち、ディレクトリ名が `archive`/`legacy` で始まるものを除外する。
- 根拠資料: `docs/specs/phase2-automation-spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__validator-enhancement-backlog-reflection` の計画具体化を行い、validator 強化項目を運用バックログへ反映する。
2. Task 3 完了時に `review.md` / `state.json` / `docs/operations/high-priority-backlog.md` / `MEMORY.md` を更新する。
3. 次タスク開始前にコミット済みであることを確認し、作業ツリー clean を維持する。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
