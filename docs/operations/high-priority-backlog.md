# 高優先バックログ

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

次に着手すべき高優先タスクを docs から俯瞰できるようにする。

## 利用ガイド（Human-Centric）

1. 使い方:
   - `優先タスク一覧` から最上位の `plan-ready` タスクを起点に着手する。
2. 仕組み:
   - `depends_on` と `依存状態` で着手可否を判定し、未解決依存があれば先行タスクへ戻る。
3. 実装:
   - 完了時は `state.json`、`review.md`、`docs/INDEX.md`、`MEMORY.md` と同時更新する。
4. 関連:
   - 詳細ルールは `AGENTS.md`、進行支援は `Rail10:list-planned-tasks-by-backlog-priority` を参照する。

## 優先タスク一覧

- `2026-02-20__define-kpi-report-execution-calendar`
- 状態: planned
- 計画段階: plan-draft
- ゲート状態: plan-ready
- 依存: `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
- 依存状態: 解決済み
- 目的: KPI レポートの週次/リリース前実行タイミングを運用カレンダーへ反映する
- 参照: `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`

- `2026-02-20__run-wave3-doc-operations-review`
- 状態: planned
- 計画段階: plan-draft
- ゲート状態: dependency-blocked
- 依存: `2026-02-20__define-kpi-report-execution-calendar`
- 依存状態: 未解決
- 目的: wave3 docs 3資料の運用レビュー観点を定義し改善起票へ接続する
- 参照: `work/2026-02-20__run-wave3-doc-operations-review/spec.md`

## Completed

1. `2026-02-20__redesign-human-centric-doc-bank-governance`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: フレームワークの目的を「再現性 + 人間理解」へ拡張し、資料バンク運用の再設計計画を確定する
- 参照: `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`

2. `2026-02-20__define-runtime-manifest-and-export-flow`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: runtime 配布対象を allowlist 化し、`dist/runtime` の再現可能な export フローを確立する
- 参照: `work/2026-02-20__define-runtime-manifest-and-export-flow/spec.md`

3. `2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- 状態: done
- 依存: `2026-02-20__define-runtime-manifest-and-export-flow`
- 依存状態: 解決済み
- 目的: 外部利用時の成果物を `.agentrail/work` に統一し、runtime インストーラで導入を自動化する
- 参照: `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md`

4. `2026-02-20__normalize-remaining-investigation-heading-terms`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: 残存する `観測方法/観測結果` 見出しを併記方針へ統一する
- 参照: `work/2026-02-20__normalize-remaining-investigation-heading-terms/spec.md`

5. `2026-02-20__add-plan-template-and-index-link`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `plan.md` 用テンプレート導線を `docs/templates` と `docs/INDEX.md` に整備する
- 参照: `work/2026-02-20__add-plan-template-and-index-link/spec.md`

6. `2026-02-20__fix-invalid-docs-path-in-self-improvement-spec`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `work/2026-02-18__self-improvement-loop-enforcement/spec.md` の実在しない docs パス記述を修正する
- 参照: `work/2026-02-20__fix-invalid-docs-path-in-self-improvement-spec/spec.md`

7. `2026-02-20__add-sidecar-log-rule-to-visual-guide`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: 可視化ガイドの委譲契約説明へ sidecar 監査ログ要件を追記する
- 参照: `work/2026-02-20__add-sidecar-log-rule-to-visual-guide/spec.md`

8. `2026-02-20__fix-improvement-create-task-dependency-placeholder`
- 状態: done
- 依存: `2026-02-20__fix-improvement-create-task-parser-errors`
- 依存状態: 解決済み
- 目的: create-task の生成文面から `$depends_on` プレースホルダ残留を除去する
- 参照: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/spec.md`

9. `2026-02-20__allow-schema-governance-without-base-sha`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: BaseSha なし（初回 push など）の schema governance 判定を運用可能な形へ修正する
- 参照: `work/2026-02-20__allow-schema-governance-without-base-sha/spec.md`

10. `2026-02-20__align-workflow-dispatch-task-id-contract`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `workflow_dispatch` の task_id 入力契約と `resolve-task-id` の挙動を一致させる
- 参照: `work/2026-02-20__align-workflow-dispatch-task-id-contract/spec.md`

11. `2026-02-20__fix-improvement-create-task-parser-errors`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `tools/improvement-harvest/create-task.ps1` の構文エラーを解消し、改善タスク自動起票を復旧する
- 参照: `work/2026-02-20__fix-improvement-create-task-parser-errors/spec.md`

12. `2026-02-19__ci-profile-schema-version-governance-gate`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: `schema_version` 更新運用（2.x 以降）を CI で強制し、破壊的変更時の versioning 不整合を fail-fast で検出する
- 参照: `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- 元候補: `docs/operations/validator-enhancement-backlog.md` の VE-006

13. `2026-02-19__rail10-skill-command-path-fix`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`
- 依存状態: 解決済み
- 目的: `Rail10:list-planned-tasks-by-backlog-priority` の `SKILL.md` コマンド案内を `$HOME/.agents/...` 依存からスキル同梱 `scripts/` 実行へ統一する
- 参照: `work/2026-02-19__rail10-skill-command-path-fix/spec.md`

14. `2026-02-19__task-doc-prerequisite-knowledge-section`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`
- 依存状態: 解決済み
- 目的: 仕様資料と task 資料へ前提知識セクションを標準化し、どの資料からでも遡及理解できる導線を運用要件として定義する
- 参照: `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`

15. `2026-02-19__task-dependency-aware-prioritization-flow`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: タスク依存関係を起票時・着手時・backlog表示・Rail10表示に組み込み、先行完了タスクを優先する運用フローを定義する
- 参照: `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md`

16. `2026-02-19__task-commit-boundary-automation-flow`
- 状態: done
- 目的: 起票後・実行後などの節目で境界コミットを標準化し、異なる作業差分のstage混在を防ぐ運用フローを定義する
- 参照: `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`

17. `2026-02-19__profile-version-schema-version-unification-strategy`
- 状態: done
- 目的: `project.profile.yaml` から `version` を廃止し、`schema_version` 単一運用へ統合する
- 参照: `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`

18. `2026-02-19__state-validator-history-strategy`
- 状態: done
- 目的: state history の管理方式を「Git 履歴への外部化」に決定し、state.json への履歴混入を validator で防止する
- 参照: `work/2026-02-19__state-validator-history-strategy/spec.md`

19. `2026-02-19__profile-validator-schema-version-field`
- 状態: done
- 目的: `project.profile.yaml` に `schema_version` を導入し、profile validator の互換ポリシーを明確化する
- 参照: `work/2026-02-19__profile-validator-schema-version-field/spec.md`

20. `2026-02-19__state-validator-done-docs-index-consistency`
- 状態: done
- 目的: state validator の `done` 判定に docs/INDEX 反映整合検証を追加し、完了条件の運用品質を強化する
- 参照: `work/2026-02-19__state-validator-done-docs-index-consistency/spec.md`

21. `2026-02-19__profile-validator-required-checks-source-of-truth`
- 状態: done
- 目的: profile validator の required key 判定を schema 定義参照へ移行し、更新漏れリスクを低減する
- 参照: `work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md`

22. `2026-02-18__validator-enhancement-backlog-reflection`
- 状態: done
- 目的: profile/state validator の強化項目を構造化して運用バックログへ反映する
- 参照: `work/2026-02-18__validator-enhancement-backlog-reflection/spec.md`

23. `2026-02-18__consistency-check-all-tasks-exclusion-rules`
- 状態: done
- 目的: `-AllTasks` 実行時の除外条件（archive/legacy）を定義する
- 参照: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`

24. `2026-02-18__consistency-check-json-schema-version-policy`
- 状態: done
- 目的: consistency-check JSON 出力に `schema_version` を追加し、互換方針を定義する
- 参照: `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`

25. `2026-02-18__ci-task-resolution-no-fallback`
- 状態: done
- 目的: task-id fallback を廃止し、差分0件時は checker を skip する
- 参照: `work/2026-02-18__ci-task-resolution-no-fallback/spec.md`

26. `2026-02-18__docs-indexer-check-mode`
- 状態: done
- 目的: `docs-indexer` の `check` モードを導入し、CI 判定を非破壊化
- 参照: `work/2026-02-18__docs-indexer-check-mode/spec.md`

27. `2026-02-18__project-profile-schema-validation`
- 状態: done
- 目的: `project.profile.yaml` の専用 validator 導入
- 参照: `work/2026-02-18__project-profile-schema-validation/spec.md`

28. `2026-02-18__state-transition-validation`
- 状態: done
- 目的: `state.json` の整合検証を CI に導入
- 参照: `work/2026-02-18__state-transition-validation/spec.md`

29. `2026-02-18__consistency-check-json-output`
- 状態: done
- 目的: `check_consistency` に JSON 出力を追加し機械可読性を向上する
- 参照: `work/2026-02-18__consistency-check-json-output/spec.md`

30. `2026-02-18__consistency-check-multi-task-mode`
- 状態: done
- 目的: `check_consistency` に複数 task 一括検査モードを追加する
- 参照: `work/2026-02-18__consistency-check-multi-task-mode/spec.md`

31. `2026-02-18__framework-request-to-commit-visual-guide`
- 状態: done
- 目的: 要望提示から実装・コミットまでの流れを図解し、CLI 要望例と AI 応答例を含む運用資料を作成する
- 参照: `work/2026-02-18__framework-request-to-commit-visual-guide/spec.md`

32. `2026-02-18__self-improvement-loop-enforcement`
- 状態: done
- 目的: Process Findings + 改善起票強制 + CI 改善ゲート導入
- 参照: `work/2026-02-18__self-improvement-loop-enforcement/spec.md`

33. `2026-02-19__existing-docs-prerequisites-retrofit`
- 状態: done
- 依存: `2026-02-19__task-doc-prerequisite-knowledge-section`
- 依存状態: 解決済み
- 目的: 既存資料（`docs/` と `work/` の archive/legacy 除外）へ前提知識セクションを優先度順で遡及適用する
- 参照: `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`

34. `2026-02-20__dependency-gate-before-plan-flow`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`, `2026-02-19__task-commit-boundary-automation-flow`
- 依存状態: 解決済み
- 目的: `plan-draft -> depends_on gate -> plan-final` の2段階計画フローを導入し、依存未解決時の final 計画確定を抑止する
- 参照: `work/2026-02-20__dependency-gate-before-plan-flow/spec.md`

35. `2026-02-20__plan-draft-before-kickoff-commit-flow`
- 状態: done
- 依存: `2026-02-19__task-commit-boundary-automation-flow`, `2026-02-19__task-dependency-aware-prioritization-flow`, `2026-02-20__dependency-gate-before-plan-flow`
- 依存状態: 解決済み
- 目的: `plan-draft` を起票境界コミット前に確定する順序へ統一し、可視化ガイドの順序不整合を解消する
- 参照: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/spec.md`

36. `2026-02-20__subagent-multi-agent-delegation-governance`
- 状態: done
- 依存: `2026-02-19__task-dependency-aware-prioritization-flow`, `2026-02-19__task-commit-boundary-automation-flow`, `2026-02-19__task-doc-prerequisite-knowledge-section`
- 依存状態: 解決済み
- 目的: subagent / multi_agent の委譲範囲を request / investigation / spec / plan-draft へ拡張し、親ゲート通過前の kickoff と次工程進行を抑止する運用を定義する
- 参照: `work/2026-02-20__subagent-multi-agent-delegation-governance/spec.md`

37. `2026-02-20__refactor-tools-to-profile-driven-runtime-paths`
- 状態: done
- 依存: `2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- 依存状態: 解決済み
- 目的: `tools/*` の固定パス参照を `project.profile.yaml` 起点へ統一し、`.agentrail/work` レイアウトを正式対応する
- 参照: `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/spec.md`

38. `2026-02-20__split-framework-runtime-rules-from-agents`
- 状態: done
- 依存: `2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- 依存状態: 解決済み
- 目的: フレームワーク動作に必須な記述を別ファイルへ分離し、`AGENTS.md` は要旨と参照リンク中心に整理する
- 参照: `work/2026-02-20__split-framework-runtime-rules-from-agents/spec.md`

39. `2026-02-20__plan-runtime-package-distribution-migration`
- 状態: done
- 依存: `2026-02-20__refactor-tools-to-profile-driven-runtime-paths`, `2026-02-20__split-framework-runtime-rules-from-agents`
- 依存状態: 解決済み
- 目的: `dist/runtime` コピー配布から package 配布へ移行する条件・互換ポリシー・実施手順を定義する
- 参照: `work/2026-02-20__plan-runtime-package-distribution-migration/spec.md`

40. `2026-02-20__plan-migration-to-human-centric-doc-bank`
- 状態: done
- 依存: `2026-02-20__redesign-human-centric-doc-bank-governance`
- 依存状態: 解決済み
- 目的: 既存 docs/運用仕組みを人間理解中心設計へ移行する wave 計画とタスク分割方針を定義する
- 参照: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`

41. `2026-02-20__wave0-inventory-human-centric-doc-coverage`
- 状態: done
- 依存: `2026-02-20__plan-migration-to-human-centric-doc-bank`
- 依存状態: 解決済み
- 目的: must 対象資料の棚卸しと欠落カテゴリ（目的/使い方/仕組み/実装/関連）の可視化を行う
- 参照: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`

42. `2026-02-20__wave0-define-doc-ownership-and-update-matrix`
- 状態: done
- 依存: `2026-02-20__wave0-inventory-human-centric-doc-coverage`
- 依存状態: 解決済み
- 目的: task owner / implementation owner / reviewer の責務を資料単位で定義する
- 参照: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`

43. `2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
- 状態: done
- 依存: `2026-02-20__wave0-inventory-human-centric-doc-coverage`
- 依存状態: 解決済み
- 目的: AGENTS.md / README.md / docs/INDEX.md を人間理解中心の情報モデルへ適合させる
- 参照: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/spec.md`

44. `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
- 状態: done
- 依存: `2026-02-20__wave0-inventory-human-centric-doc-coverage`
- 依存状態: 解決済み
- 目的: docs/operations の主要資料を情報モデルに合わせて補完・再編する
- 参照: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`

45. `2026-02-20__wave1-normalize-doc-work-cross-links`
- 状態: done
- 依存: `2026-02-20__wave1-migrate-core-docs-to-human-centric-model`, `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
- 依存状態: 解決済み
- 目的: docs と work の相互参照を統一し、参照切れを解消する
- 参照: `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`

46. `2026-02-20__wave2-spec-doc-quality-check-rules`
- 状態: done
- 依存: `2026-02-20__wave1-normalize-doc-work-cross-links`
- 依存状態: 解決済み
- 目的: consistency-check / state-validate へ追加する docs 品質チェック仕様を設計する
- 参照: `work/2026-02-20__wave2-spec-doc-quality-check-rules/spec.md`

47. `2026-02-20__wave2-implement-doc-quality-warning-mode`
- 状態: done
- 依存: `2026-02-20__wave2-spec-doc-quality-check-rules`
- 依存状態: 解決済み
- 目的: docs 品質チェックを warning モードで段階導入し、警告集計を可視化する
- 参照: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`

48. `2026-02-20__wave2-enforce-doc-quality-fail-mode`
- 状態: done
- 依存: `2026-02-20__wave2-implement-doc-quality-warning-mode`
- 依存状態: 解決済み
- 目的: CI の対象 task 経路で docs 品質チェックを fail モードへ昇格する
- 参照: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`

49. `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`
- 状態: done
- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`
- 依存状態: 解決済み
- 目的: CI運用資料を docs 品質ゲートに合わせて更新し、運用手順を整合させる
- 参照: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`

50. `2026-02-20__wave3-define-doc-quality-kpi-thresholds`
- 状態: done
- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`, `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`
- 依存状態: 解決済み
- 目的: 更新遅延 / 導線整合 / 網羅率の KPI 指標と暫定閾値を定義する
- 参照: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`

51. `2026-02-20__wave3-automate-doc-quality-metrics-report`
- 状態: done
- 依存: `2026-02-20__wave3-define-doc-quality-kpi-thresholds`
- 依存状態: 解決済み
- 目的: docs 品質 KPI の自動集計と可視化レポートを設計・実装する
- 参照: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`

52. `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
- 状態: done
- 依存: `2026-02-20__wave3-automate-doc-quality-metrics-report`
- 依存状態: 解決済み
- 目的: KPI悪化時に Process Findings から改善タスクへ接続する運用を定義する
- 参照: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`

53. `2026-02-20__prioritize-dq002-warning-remediation`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: DQ-002 warning 21件の解消優先順と分割起票方針を策定する
- 参照: `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`

54. `2026-02-20__fix-wave3-investigation-broken-tmp-reference`
- 状態: done
- 依存: なし
- 依存状態: なし
- 目的: wave3 investigation の一時参照切れを修正し、checker fail を解消する
- 参照: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`

## 更新ルール

- task の状態を更新したら本資料も同時更新する。
- `planned` タスクには `計画段階`、`ゲート状態`、`依存` と `依存状態` を必ず記載する。
- `依存` は `state.json` の `depends_on` と一致させる。
- `計画段階` は `plan-draft` / `plan-final` を使用し、`ゲート状態` は `plan-ready` / `dependency-blocked` を使用する。
- 完了タスクは `Completed` セクションへ移動する。
- `review.md` の `Process Findings` で `must/high` が検出された場合は、同一PR内で follow-up task を起票して本資料へ登録する。
- 自動起票時は `tools/improvement-harvest/create-task.ps1` を使用し、`request/spec` に source task と finding ID を記録する。
