# AgentRail Claude Compatibility

このファイルは Claude Code 用の互換ガイドです。  
正本ルールは `AGENTS.md` です。矛盾がある場合は `AGENTS.md` を優先します。

## 1. 基本方針

- 作業前に `AGENTS.md` を読み、固定ワークフローに従う。
- タスク成果物は必ず `work/<task-id>/` に集約する。
- `project.profile.yaml` に定義されていないコマンドは推測実行しない。

## 2. 進行順序

1. `request.md`
2. `investigation.md`
3. `spec.md`
4. `plan.md`
5. 実装
6. テスト
7. `review.md`
8. `docs/INDEX.md` 更新
9. `MEMORY.md` 更新

## 3. ブロック条件

- `spec.md` 空欄禁止項目が未記入。
- `テスト要件` が不十分。
- `docs/INDEX.md` 未更新。
- `project.profile.yaml` 必須キー不足。

## 4. 引き継ぎ

- セッション終了時に `MEMORY.md` と `work/<task-id>/state.json` を更新する。
