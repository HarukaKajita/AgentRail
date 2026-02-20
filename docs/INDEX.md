# ドキュメントインデックス

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


このファイルは手動管理版のインデックスです。  
将来は自動生成に置き換える予定ですが、現時点では更新を必須とします。

## 0. 利用ガイド（Human-Centric）

1. 目的:
   - まず `AGENTS.md` と対象 task の `spec.md` を読む。
2. 使い方:
   - 実行手順は `README.md` と `docs/operations/*` runbook を参照する。
3. 仕組み:
   - `work/<task-id>/` と `docs/` の往復導線を確認する。
4. 実装:
   - `tools/*` と `project.profile.yaml` の実行契約を確認する。
5. 関連:
   - `docs/operations/high-priority-backlog.md` と `MEMORY.md` で進行中タスクを辿る。

## 1. 運用資料

- `docs/README.md` - docs 運用ルール
- `AGENTS.md` - AgentRail 正本ルール
- `CLAUDE.md` - Claude 互換ルール
- `MEMORY.md` - セッション引き継ぎテンプレート
- `project.profile.yaml` - 実行環境プロファイル

## 2. テンプレート
- `docs/templates/adr.md` - ADR テンプレート
- `docs/templates/investigation.md` - 調査テンプレート
- `docs/templates/plan.md` - 計画テンプレート
- `docs/templates/project-profile.md` - project.profile.yaml 記入ガイド
- `docs/templates/review.md` - Review テンプレート
- `docs/templates/spec.md` - 仕様書テンプレート

## 3. 仕様
- `docs/specs/automation-tools-ci-integration-spec.md` - 自動化基盤 CI 連携仕様
- `docs/specs/automation-tools-design-spec.md` - 自動化基盤仕様（設計）
- `docs/specs/automation-tools-implementation-spec.md` - 自動化基盤 実装仕様
- `docs/specs/framework-pilot-01-spec.md` - Framework Pilot 01 仕様
- `docs/specs/self-improvement-loop-spec.md` - 自己改善ループ仕様

## 4. 意思決定
- `docs/decisions/20260218-ci-governance-and-task-resolution.md` - CI ガバナンスと task-id 解決戦略
- `docs/decisions/20260218-self-improvement-loop-enforcement.md` - 自己改善ループ強制方針

## 5. 調査
- `docs/investigations/automation-tools-ci-integration-investigation.md` - 自動化基盤 CI 連携調査記録
- `docs/investigations/automation-tools-implementation-investigation.md` - 自動化基盤 実装調査記録
- `docs/investigations/framework-pilot-01-investigation.md` - Framework Pilot 01 調査記録
- `docs/investigations/self-improvement-loop-investigation.md` - 自己改善ループ導入調査

## 6. 運用
- `docs/operations/ci-failure-runbook.md` - CI 失敗時ランブック
- `docs/operations/framework-request-to-commit-visual-guide.md` - ユーザー要望から実装・コミットまでのフロー可視化ガイド
- `docs/operations/high-priority-backlog.md` - 高優先バックログ
- `docs/operations/human-centric-doc-bank-governance.md` - Human-Centric Doc Bank Governance
- `docs/operations/human-centric-doc-bank-migration-plan.md` - Human-Centric Doc Bank Migration Plan
- `docs/operations/legacy-documents-policy.md` - 旧資料の隔離運用ポリシー
- `docs/operations/profile-validator-required-checks-source-of-truth.md` - Profile Validator Required Checks Source Of Truth
- `docs/operations/profile-validator-schema-version-policy.md` - Profile Validator Schema Version Policy
- `docs/operations/runtime-distribution-export-guide.md` - Runtime Distribution Export Guide
- `docs/operations/runtime-framework-rules.md` - Runtime Framework Rules
- `docs/operations/runtime-installation-runbook.md` - Runtime Installation Runbook
- `docs/operations/runtime-package-distribution-migration-plan.md` - Runtime Package Distribution Migration Plan
- `docs/operations/skills-framework-flow-guide.md` - Skills Framework Flow Guide
- `docs/operations/skills-sync-runbook.md` - Skills Sync Runbook
- `docs/operations/stage-terminology.md` - 開発段階用語集
- `docs/operations/state-history-strategy.md` - State History Strategy
- `docs/operations/state-validator-done-docs-index-consistency.md` - State Validator Done Docs Index Consistency
- `docs/operations/validator-enhancement-backlog.md` - Validator Enhancement Backlog
- `docs/operations/wave0-doc-ownership-and-update-matrix.md` - Wave 0: Doc Ownership And Update Matrix
- `docs/operations/wave0-inventory-human-centric-doc-coverage.md` - Wave 0 Inventory: Human-Centric Doc Coverage
- `docs/operations/wave1-core-docs-human-centric-migration.md` - Wave 1 Core Docs: Human-Centric Migration
- `docs/operations/wave1-doc-work-cross-link-normalization.md` - Wave 1: Doc-Work Cross-Link Normalization
- `docs/operations/wave1-operations-docs-human-centric-migration.md` - Wave 1 Operations Docs: Human-Centric Migration
- `docs/operations/wave2-doc-quality-check-rules-spec.md` - Wave 2 Spec: Doc Quality Check Rules
- `docs/operations/wave2-doc-quality-fail-mode.md` - Wave 2: Doc Quality Fail Mode
- `docs/operations/wave2-doc-quality-warning-mode.md` - Wave 2: Doc Quality Warning Mode
- `docs/operations/wave3-doc-quality-kpi-thresholds.md` - Wave 3: Doc Quality KPI Thresholds
- `docs/operations/wave3-doc-quality-metrics-report-automation.md` - Wave 3: Doc Quality Metrics Report Automation

## 7. 更新手順

1. 新規または更新した資料を上記カテゴリに追加する。
2. パスの存在確認を行う。
3. タスク完了前に更新漏れがないか確認する。
4. profile schema 運用変更時は `docs/operations/profile-validator-schema-version-policy.md` を優先参照する。
5. profile schema 変更を含む PR では `tools/profile-validate/check-schema-governance.ps1` の PASS を確認する。

