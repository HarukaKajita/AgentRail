# 高優先バックログ

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

次に着手すべき高優先タスクを docs から俯瞰できるようにする。

## 優先タスク一覧

1. `2026-02-20__subagent-multi-agent-delegation-governance`
- 状態: planned
- 計画段階: plan-draft
- ゲート状態: plan-ready
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`, `2026-02-19__task-commit-boundary-automation-flow`, `2026-02-19__task-doc-prerequisite-knowledge-section`
- 依存状態: 解決済み
- 目的: 各工程で subagent / multi_agent を標準活用しつつ、品質低下懸念工程を例外化する運用ルールを仕様化する
- 参照: `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`

## Completed

1. `2026-02-19__ci-profile-schema-version-governance-gate`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `schema_version` 更新運用（2.x 以降）を CI で強制し、破壊的変更時の versioning 不整合を fail-fast で検出する
- 参照: `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- 元候補: `docs/operations/validator-enhancement-backlog.md` の VE-006

2. `2026-02-19__rail10-skill-command-path-fix`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`
- 依存状態: 解決済み
- 目的: `Rail10:list-planned-tasks-by-backlog-priority` の `SKILL.md` コマンド案内を `$HOME/.agents/...` 依存からスキル同梱 `scripts/` 実行へ統一する
- 参照: `work/2026-02-19__rail10-skill-command-path-fix/spec.md`

3. `2026-02-19__task-doc-prerequisite-knowledge-section`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`
- 依存状態: 解決済み
- 目的: 仕様資料と task 資料へ前提知識セクションを標準化し、どの資料からでも遡及理解できる導線を運用要件として定義する
- 参照: `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`

4. `2026-02-19__task-dependency-aware-prioritization-flow`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: タスク依存関係を起票時・着手時・backlog表示・Rail10表示に組み込み、先行完了タスクを優先する運用フローを定義する
- 参照: `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md`

5. `2026-02-19__task-commit-boundary-automation-flow`
- 状態: done
- 目的: 起票後・実行後などの節目で境界コミットを標準化し、異なる作業差分のstage混在を防ぐ運用フローを定義する
- 参照: `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`

6. `2026-02-19__profile-version-schema-version-unification-strategy`
- 状態: done
- 目的: `project.profile.yaml` から `version` を廃止し、`schema_version` 単一運用へ統合する
- 参照: `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`

7. `2026-02-19__state-validator-history-strategy`
- 状態: done
- 目的: state history の管理方式を「Git 履歴への外部化」に決定し、state.json への履歴混入を validator で防止する
- 参照: `work/2026-02-19__state-validator-history-strategy/spec.md`

8. `2026-02-19__profile-validator-schema-version-field`
- 状態: done
- 目的: `project.profile.yaml` に `schema_version` を導入し、profile validator の互換ポリシーを明確化する
- 参照: `work/2026-02-19__profile-validator-schema-version-field/spec.md`

9. `2026-02-19__state-validator-done-docs-index-consistency`
- 状態: done
- 目的: state validator の `done` 判定に docs/INDEX 反映整合検証を追加し、完了条件の運用品質を強化する
- 参照: `work/2026-02-19__state-validator-done-docs-index-consistency/spec.md`

10. `2026-02-19__profile-validator-required-checks-source-of-truth`
- 状態: done
- 目的: profile validator の required key 判定を schema 定義参照へ移行し、更新漏れリスクを低減する
- 参照: `work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md`

11. `2026-02-18__validator-enhancement-backlog-reflection`
- 状態: done
- 目的: profile/state validator の強化項目を構造化して運用バックログへ反映する
- 参照: `work/2026-02-18__validator-enhancement-backlog-reflection/spec.md`

12. `2026-02-18__consistency-check-all-tasks-exclusion-rules`
- 状態: done
- 目的: `-AllTasks` 実行時の除外条件（archive/legacy）を定義する
- 参照: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`

13. `2026-02-18__consistency-check-json-schema-version-policy`
- 状態: done
- 目的: consistency-check JSON 出力に `schema_version` を追加し、互換方針を定義する
- 参照: `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`

14. `2026-02-18__ci-task-resolution-no-fallback`
- 状態: done
- 目的: task-id fallback を廃止し、差分0件時は checker を skip する
- 参照: `work/2026-02-18__ci-task-resolution-no-fallback/spec.md`

15. `2026-02-18__docs-indexer-check-mode`
- 状態: done
- 目的: `docs-indexer` の `check` モードを導入し、CI 判定を非破壊化
- 参照: `work/2026-02-18__docs-indexer-check-mode/spec.md`

16. `2026-02-18__project-profile-schema-validation`
- 状態: done
- 目的: `project.profile.yaml` の専用 validator 導入
- 参照: `work/2026-02-18__project-profile-schema-validation/spec.md`

17. `2026-02-18__state-transition-validation`
- 状態: done
- 目的: `state.json` の整合検証を CI に導入
- 参照: `work/2026-02-18__state-transition-validation/spec.md`

18. `2026-02-18__consistency-check-json-output`
- 状態: done
- 目的: `check_consistency` に JSON 出力を追加し機械可読性を向上する
- 参照: `work/2026-02-18__consistency-check-json-output/spec.md`

19. `2026-02-18__consistency-check-multi-task-mode`
- 状態: done
- 目的: `check_consistency` に複数 task 一括検査モードを追加する
- 参照: `work/2026-02-18__consistency-check-multi-task-mode/spec.md`

20. `2026-02-18__framework-request-to-commit-visual-guide`
- 状態: done
- 目的: 要望提示から実装・コミットまでの流れを図解し、CLI 要望例と AI 応答例を含む運用資料を作成する
- 参照: `work/2026-02-18__framework-request-to-commit-visual-guide/spec.md`

21. `2026-02-18__self-improvement-loop-enforcement`
- 状態: done
- 目的: Process Findings + 改善起票強制 + CI 改善ゲート導入
- 参照: `work/2026-02-18__self-improvement-loop-enforcement/spec.md`

22. `2026-02-19__existing-docs-prerequisites-retrofit`
- 状態: done
- 依存: `2026-02-19__task-doc-prerequisite-knowledge-section`
- 依存状態: 解決済み
- 目的: 既存資料（`docs/` と `work/` の archive/legacy 除外）へ前提知識セクションを優先度順で遡及適用する
- 参照: `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`

23. `2026-02-20__dependency-gate-before-plan-flow`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`, `2026-02-19__task-commit-boundary-automation-flow`
- 依存状態: 解決済み
- 目的: `plan-draft -> depends_on gate -> plan-final` の2段階計画フローを導入し、依存未解決時の final 計画確定を抑止する
- 参照: `work/2026-02-20__dependency-gate-before-plan-flow/spec.md`

## 更新ルール

- task の状態を更新したら本資料も同時更新する。
- `planned` タスクには `計画段階`、`ゲート状態`、`依存` と `依存状態` を必ず記載する。
- `依存` は `state.json` の `depends_on` と一致させる。
- `計画段階` は `plan-draft` / `plan-final` を使用し、`ゲート状態` は `plan-ready` / `dependency-blocked` を使用する。
- 完了タスクは `Completed` セクションへ移動する。
- `review.md` の `Process Findings` で `must/high` が検出された場合は、同一PR内で follow-up task を起票して本資料へ登録する。
- 自動起票時は `tools/improvement-harvest/create-task.ps1` を使用し、`request/spec` に source task と finding ID を記録する。
