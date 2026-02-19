# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__task-dependency-aware-prioritization-flow
- タイトル: Dependency-Aware Task Prioritization Flow
- 状態: planned
- 最終更新日時: 2026-02-19T20:48:29+09:00
- 担当: codex

## 2. 今回の目的

- タスク依存関係を起票時・着手時・backlog表示・Rail10表示に組み込み、先行完了タスクを優先する運用を実装する。
- 起票済みタスクを優先順で1件ずつ完了し、タスク間で必ずコミット境界を設ける。

## 3. 完了済み

- `2026-02-19__task-commit-boundary-automation-flow` を完了し、`state=done` に更新した。
- 境界コミット運用を `AGENTS.md` と運用docsに追加した。
- `tools/commit-boundary/check-staged-files.ps1` と `tools/commit-boundary/commit-phase.ps1` を追加した。
- `tools/consistency-check/check.ps1` に commit boundary 追跡検証を追加した（commit boundary 適用タスクのみ強制）。
- `.agents` / `agents` の Rail1/Rail6/Rail10 スキルへ境界コミット確認ルールを追加した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: コミット境界は「起票後」「実装後」「完了後」の3段階を標準とする。
- 決定内容: 差分混在防止は `tools/commit-boundary/check-staged-files.ps1` で fail-fast する。
- 決定内容: 完了タスクの review では `## 7. Commit Boundaries` に境界コミット情報を記録する。
- 根拠資料:
  - `AGENTS.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `work/2026-02-19__task-commit-boundary-automation-flow/review.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-19__task-dependency-aware-prioritization-flow` を実装着手する。
2. 依存関係モデル、着手ゲート、Rail10 表示拡張を反映する。
3. タスク完了時に境界コミットを実施して次タスクへ進む。

## 7. 参照先

- `work/2026-02-19__task-commit-boundary-automation-flow/request.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/investigation.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/plan.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/review.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
