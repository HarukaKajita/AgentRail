# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-18__consistency-check-json-schema-version-policy
- タイトル: Consistency Check JSON Schema Version Policy
- 状態: done
- 最終更新日時: 2026-02-19T01:01:17+09:00
- 担当: Codex

## 2. 今回の目的

- `consistency-check` JSON 出力へ `schema_version` を追加する。
- JSON スキーマ互換ポリシー（major/minor/patch）を docs へ明文化する。
- task 成果物・バックログ状態・レビュー結果を整合させる。

## 3. 完了済み

- `tools/consistency-check/check.ps1` に `schema_version` (`1.0.0`) を追加し、single/multi 両 JSON 出力へ反映した。
- `docs/specs/phase2-automation-spec.md` に `schema_version` を含む JSON スキーマ例と互換ポリシーを追記した。
- `work/2026-02-18__consistency-check-json-schema-version-policy/{investigation,spec,plan,review,state.json}` を更新した。
- `docs/operations/high-priority-backlog.md` で本タスクを Completed へ移動した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: consistency-check JSON schema の初期版を `1.0.0` とし、互換追加は minor、破壊変更は major を採用する。
- 根拠資料: `docs/specs/phase2-automation-spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-18__consistency-check-all-tasks-exclusion-rules` の計画具体化を行い、`-AllTasks` 除外条件を実装する。
2. `2026-02-18__validator-enhancement-backlog-reflection` の計画具体化を行い、validator 強化項目を運用バックログへ反映する。
3. 各タスク完了時に都度コミットし、次タスク開始前に作業ツリーを clean にする。

## 7. 参照先

- work/<task-id>/request.md
- work/<task-id>/spec.md
- work/<task-id>/plan.md
- work/<task-id>/review.md

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
