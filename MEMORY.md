# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-20__run-wave3-doc-operations-review
- タイトル: Wave3 Docs 運用レビュー（起票）
- 状態: planned
- 最終更新日時: 2026-02-20T20:14:00+09:00
- 担当: codex

## 2. 今回の目的

- human-centric doc bank の Wave 0-3 実行タスクを依存順で完了させる。
- 各タスクを完了ごとにコミットし、backlog/state/docs/メモの整合を維持する。

## 3. 完了済み

- `2026-02-20__define-runtime-manifest-and-export-flow` を完了。
  - `framework.runtime.manifest.yaml` を追加。
  - `runtime/seed/*` を追加。
  - `tools/runtime/export-runtime.ps1` を追加（apply/check/dry-run）。
  - `docs/operations/runtime-distribution-export-guide.md` を追加。
- `2026-02-20__add-runtime-installer-with-agentrail-work-layout` を完了。
  - `tools/runtime/install-runtime.ps1` を追加（dry-run/force/profile更新）。
  - `docs/operations/runtime-installation-runbook.md` を追加。
  - installer で `.agentrail/work/.gitkeep` 生成、`workflow.task_root` / `workflow.runtime_root`、`paths.*` の更新を確認。
- `2026-02-20__refactor-tools-to-profile-driven-runtime-paths` を完了。
  - `tools/common/profile-paths.ps1` を追加し、workflow root の共通解決を導入。
  - `consistency/state/resolve/improvement/commit-boundary` 系ツールの `work/docs` 固定参照を profile 起点へ置換。
  - `.agentrail/work` / `.agentrail/docs` プロファイルのスモーク検証で create/check/validate を確認。
- `2026-02-20__split-framework-runtime-rules-from-agents` を完了。
  - `docs/operations/runtime-framework-rules.md` を追加し、runtime 必須ルールを正本化。
  - `AGENTS.md` は runtime 要旨と参照リンク中心へ整理。
  - `README.md` と `docs/INDEX.md` に runtime ルール導線を追加。
- `2026-02-20__plan-runtime-package-distribution-migration` を完了。
  - `docs/operations/runtime-package-distribution-migration-plan.md` を追加し、移行条件・互換ポリシー・実施フェーズ・ロールバックを定義。
  - task 側の `request/spec/plan/review/state` を完了状態へ更新。
- `2026-02-20__redesign-human-centric-doc-bank-governance` を完了。
  - `docs/operations/human-centric-doc-bank-governance.md` を追加し、運用原則・情報モデル・品質ゲートを定義。
  - `AGENTS.md` と `README.md` の目的記述を「再現性 + 人間理解」へ更新。
  - backlog と task state の依存整合を更新し、Task B を plan-ready に切り替え。
- `2026-02-20__plan-migration-to-human-centric-doc-bank` を完了。
  - `docs/operations/human-centric-doc-bank-migration-plan.md` を追加し、Wave 0-3 の移行計画を定義。
  - Task A 依存ゲートを pass 化し、Task B の `review/state/backlog` を完了状態へ更新。
- `2026-02-20__wave0-inventory-human-centric-doc-coverage` を完了。
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md` を追加し、must対象資料の棚卸し結果と欠落カテゴリマップを確定。
  - `docs/operations/high-priority-backlog.md` で Wave 1 先行タスクの依存状態を解決済みに更新。
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave0-define-doc-ownership-and-update-matrix` を完了。
  - `docs/operations/wave0-doc-ownership-and-update-matrix.md` を追加し、資料単位の責務マトリクスを定義。
  - `docs/operations/high-priority-backlog.md` で該当タスクを Completed へ移動。
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave1-migrate-core-docs-to-human-centric-model` を完了。
  - `AGENTS.md` / `README.md` / `docs/INDEX.md` に人間理解導線セクションを追加。
  - `docs/operations/wave1-core-docs-human-centric-migration.md` を追加し、core docs 移行結果を記録。
  - `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model` を完了。
  - `docs/operations/ci-failure-runbook.md` / `framework-request-to-commit-visual-guide.md` / `runtime-framework-rules.md` / `high-priority-backlog.md` へ導線補完を追加。
  - `docs/operations/wave1-operations-docs-human-centric-migration.md` を追加し、operations docs 移行結果を記録。
  - `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave1-normalize-doc-work-cross-links` を完了。
  - `docs/operations/wave1-doc-work-cross-link-normalization.md` を追加し、相互リンク標準ルールを定義。
  - `docs/operations/wave1-core-docs-human-centric-migration.md` / `wave1-operations-docs-human-centric-migration.md` に関連 task リンクを統一形式で追記。
  - `work/2026-02-20__wave1-normalize-doc-work-cross-links/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave2-spec-doc-quality-check-rules` を完了。
  - `docs/operations/wave2-doc-quality-check-rules-spec.md` を追加し、DQ-001〜DQ-004 と warning/fail 段階導入方針を定義。
  - `docs/operations/high-priority-backlog.md` で warning 導入タスクを plan-ready に更新。
  - `work/2026-02-20__wave2-spec-doc-quality-check-rules/{plan,spec,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave2-implement-doc-quality-warning-mode` を完了。
  - `tools/consistency-check/check.ps1` / `tools/state-validate/validate.ps1` に `DocQualityMode off|warning|fail` を追加。
  - warning summary（`total_rules / warning_count / error_count`）を text 出力へ追加し、`consistency-check` の json 出力へ doc quality セクションを追加。
  - `docs/operations/wave2-doc-quality-warning-mode.md` を追加し、warning 運用手順と観測値（warning=21）を記録。
  - `docs/operations/high-priority-backlog.md` で fail 昇格タスクを plan-ready に更新。
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave2-enforce-doc-quality-fail-mode` を完了。
  - `.github/workflows/ci-framework.yml` の変更対象 task 経路に `DocQualityMode=fail` を適用。
  - `docs/operations/wave2-doc-quality-fail-mode.md` を追加し、fail 適用条件と rollback 方針を定義。
  - `docs/operations/high-priority-backlog.md` で `wave2-align-ci-runbook` を plan-ready に更新。
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates` を完了。
  - `docs/operations/ci-failure-runbook.md` を CI の warning/fail 二段ゲート順序へ再構成。
  - `docs/operations/framework-request-to-commit-visual-guide.md` のチェック手順を state-validate 併用へ更新。
  - `docs/operations/high-priority-backlog.md` で `wave3-define-doc-quality-kpi-thresholds` を plan-ready に更新。
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave3-define-doc-quality-kpi-thresholds` を完了。
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md` を追加し、3 KPI と暫定閾値/guardrail/baseline を定義。
  - `docs/operations/high-priority-backlog.md` で `wave3-automate-doc-quality-metrics-report` を plan-ready に更新。
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave3-automate-doc-quality-metrics-report` を完了。
  - `tools/doc-quality/generate-kpi-report.ps1` を追加し、KPI の JSON/Markdown レポート自動生成を実装。
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md` を追加し、実行手順と出力仕様を定義。
  - `docs/operations/high-priority-backlog.md` で `wave3-connect-kpi-to-process-findings-loop` を plan-ready に更新。
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- `2026-02-20__wave3-connect-kpi-to-process-findings-loop` を完了。
  - `tools/doc-quality/generate-finding-template.ps1` を追加し、KPI report から Process Finding テンプレートを生成可能化。
  - `docs/operations/wave3-kpi-process-findings-loop.md` を追加し、decision table と create-task 接続手順を定義。
  - `docs/operations/high-priority-backlog.md` で Wave 3 実行タスクをすべて Completed へ移動。
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/{request,investigation,spec,plan,review,state.json}` を done 条件へ更新。
- Wave 実行タスク 12 件を起票。
  - Wave 0: `2026-02-20__wave0-inventory-human-centric-doc-coverage`, `2026-02-20__wave0-define-doc-ownership-and-update-matrix`
  - Wave 1: `2026-02-20__wave1-migrate-core-docs-to-human-centric-model`, `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`, `2026-02-20__wave1-normalize-doc-work-cross-links`
  - Wave 2: `2026-02-20__wave2-spec-doc-quality-check-rules`, `2026-02-20__wave2-implement-doc-quality-warning-mode`, `2026-02-20__wave2-enforce-doc-quality-fail-mode`, `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`
  - Wave 3: `2026-02-20__wave3-define-doc-quality-kpi-thresholds`, `2026-02-20__wave3-automate-doc-quality-metrics-report`, `2026-02-20__wave3-connect-kpi-to-process-findings-loop`

## 4. 重要な意思決定

- runtime 配布の SSOT は `framework.runtime.manifest.yaml` とする。
- runtime 配布物の初期ファイルは `runtime/seed/*` で上書きする。
- 導入先の task root は `.agentrail/work` に統一する。
- package 化は別タスク（`2026-02-20__plan-runtime-package-distribution-migration`）で計画先行する。
- 人間理解中心 docs ガバナンスの正本は `docs/operations/human-centric-doc-bank-governance.md` とする。
- 既存資産移行の正本計画は `docs/operations/human-centric-doc-bank-migration-plan.md` とする。

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 起票済み4タスクの依存順で実装着手候補を確定する。
2. `2026-02-20__prioritize-dq002-warning-remediation` の実装着手に進む。
3. `2026-02-20__run-wave3-doc-operations-review` の depends_on 解決後に gate 判定を更新する。

## 7. 参照先

- `docs/operations/high-priority-backlog.md`
- `docs/operations/human-centric-doc-bank-governance.md`
- `docs/operations/human-centric-doc-bank-migration-plan.md`
- `work/2026-02-20__define-runtime-manifest-and-export-flow/review.md`
- `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md`
- `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/review.md`
- `work/2026-02-20__split-framework-runtime-rules-from-agents/review.md`
- `work/2026-02-20__plan-runtime-package-distribution-migration/review.md`
- `work/2026-02-20__redesign-human-centric-doc-bank-governance/review.md`
- `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- `work/2026-02-20__plan-migration-to-human-centric-doc-bank/review.md`
- `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`
- `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`
- `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/review.md`
- `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
- `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`
- `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/review.md`
- `docs/operations/wave0-doc-ownership-and-update-matrix.md`
- `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/spec.md`
- `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/review.md`
- `docs/operations/wave1-core-docs-human-centric-migration.md`
- `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`
- `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/review.md`
- `docs/operations/wave1-operations-docs-human-centric-migration.md`
- `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`
- `work/2026-02-20__wave1-normalize-doc-work-cross-links/review.md`
- `docs/operations/wave1-doc-work-cross-link-normalization.md`
- `work/2026-02-20__wave2-spec-doc-quality-check-rules/spec.md`
- `work/2026-02-20__wave2-spec-doc-quality-check-rules/review.md`
- `docs/operations/wave2-doc-quality-check-rules-spec.md`
- `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`
- `work/2026-02-20__wave2-implement-doc-quality-warning-mode/review.md`
- `docs/operations/wave2-doc-quality-warning-mode.md`
- `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
- `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/review.md`
- `docs/operations/wave2-doc-quality-fail-mode.md`
- `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
- `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/review.md`
- `docs/operations/ci-failure-runbook.md`
- `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
- `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/review.md`
- `docs/operations/wave3-doc-quality-kpi-thresholds.md`
- `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
- `work/2026-02-20__wave3-automate-doc-quality-metrics-report/review.md`
- `docs/operations/wave3-doc-quality-metrics-report-automation.md`
- `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
- `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/review.md`
- `docs/operations/wave3-kpi-process-findings-loop.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か


