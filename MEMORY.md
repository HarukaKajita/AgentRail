# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: none
- タイトル: Backlog clearance checkpoint
- 状態: done
- 最終更新日時: 2026-02-20T13:14:45+09:00
- 担当: codex

## 2. 今回の目的

- repository review で検出した不備 8 件を修正タスクとして起票し、優先順で着手する。
- 最優先の blocker（`tools/improvement-harvest/create-task.ps1` 構文エラー）を解消する。
- 以降の CI / docs / template / task 文書不整合修正へ順次着手できる状態を整える。

## 3. 完了済み

- `2026-02-20__normalize-remaining-investigation-heading-terms` を完了。
- `2026-02-20__add-plan-template-and-index-link` を完了。
- `2026-02-20__fix-invalid-docs-path-in-self-improvement-spec` を完了。
- `2026-02-20__add-sidecar-log-rule-to-visual-guide` を完了。
- `2026-02-20__fix-improvement-create-task-dependency-placeholder` を完了。
- `2026-02-20__allow-schema-governance-without-base-sha` を完了。
- `2026-02-20__align-workflow-dispatch-task-id-contract` を完了。
- `2026-02-20__fix-improvement-create-task-parser-errors` を完了。
- `2026-02-19__existing-docs-prerequisites-retrofit` を完了。
- `2026-02-19__ci-profile-schema-version-governance-gate` を完了。
- `2026-02-19__task-commit-boundary-automation-flow` を完了。
- `2026-02-19__task-dependency-aware-prioritization-flow` を完了。
- `2026-02-19__task-doc-prerequisite-knowledge-section` を完了。
- `2026-02-19__rail10-skill-command-path-fix` を完了。
- `2026-02-20__dependency-gate-before-plan-flow` を完了。
- `2026-02-20__plan-draft-before-kickoff-commit-flow` を完了。
- `2026-02-20__subagent-multi-agent-delegation-governance` を完了。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: Rail10 のコマンド案内は `$HOME/.agents` を使わず、スキル同梱 `scripts/list_planned_tasks.ps1` 実行で統一する。
- 決定内容: active task では `前提知識` セクションを checker で必須化する。
- 決定内容: profile schema 変更時は `tools/profile-validate/check-schema-governance.ps1` を CI fail-fast gate として必須実行する。
- 決定内容: 既存資料への前提知識セクション遡及適用は P1-P3 の優先度フェーズで実施する。
- 決定内容: docs 30/30、work 130/130（archive/legacy 除外）で前提知識セクション適用を完了した。
- 決定内容: subagent / multi_agent は原則活用し、品質低下懸念工程は親エージェント固定とする方針で要件化する。
- 決定内容: ベストプラクティスに合わせ、`plan-draft -> depends_on gate -> plan-final` を採用する方針で起票する。
- 決定内容: 2段階計画フローを AGENTS/docs/Rail10/checker/state-validator へ実装し、`plan-final` は depends_on gate pass 後のみ確定可能とした。
- 決定内容: 起票境界コミットは `plan-draft` 作成後に実行する方針で統一し、可視化資料も同順序へ修正する。
- 決定内容: subagent / multi_agent の委譲範囲は request / investigation / spec / plan-draft とし、親の `gate_result=pass` 前は kickoff / depends_on gate / plan-final / commit を禁止する。
- 根拠資料:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/review.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/review.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 新規要望受領時は `docs/operations/high-priority-backlog.md` と `work/*/state.json` を突合し、優先 task から再開する。
2. 新規タスク着手前に `project.profile.yaml` と `depends_on` の gate 状態を確認する。
3. コミット前は `consistency-check` / `state-validate` / `docs-indexer` の3点を再実行する。

## 7. 参照先

- `docs/operations/high-priority-backlog.md`
- `work/2026-02-20__normalize-remaining-investigation-heading-terms/spec.md`
- `docs/templates/plan.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か

