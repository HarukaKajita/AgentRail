# ドキュメントインデックス (Document Index)

## 0. 前提知識 (Prerequisites) (必須)

- **参照資料**:
  - `AGENTS.md` (フレームワーク基本ルール)
- **理解ポイント**:
  - 各資料を読み進める前に、本フレームワークの目的、受入条件、および資料間の依存関係を把握してください。

---

本ファイルは、プロジェクト内の全ドキュメントへの導線を管理するインデックスである。  
**資料を追加・更新した際は、必ず本ファイルを更新すること。**

## 1. 人間中心の閲覧ガイド (Human-Centric Guide)

最短で必要な情報に辿り着くための推奨ルート：

1. **目的を知る**: `AGENTS.md` および対象タスクの `spec.md` を確認。
2. **使用方法を知る**: `README.md` および `docs/operations/` 配下のランブックを参照。
3. **構造を理解する**: `work/<task-id>/`（作業記録）と `docs/`（永続ドキュメント）の関係性を把握。
4. **実装詳細を確認する**: `tools/` 配下のスクリプトおよび `project.profile.yaml` を参照。
5. **現在の進捗を追う**: `docs/operations/high-priority-backlog.md` および `MEMORY.md` を参照。

## 2. 運用基本資料
- `AGENTS.md` - AgentRail 行動規範・正本ルール
- `README.md` - プロジェクト概要・導入手順
- `docs/README.md` - ドキュメント運用ルール
- `CLAUDE.md` - 特定エージェント向け互換ルール
- `MEMORY.md` - セッション継続用コンテキスト
- `project.profile.yaml` - 実行コマンド定義プロファイル

## 3. テンプレート (Templates)
- `docs/templates/adr.md` - ADR (意思決定記録) テンプレート
- `docs/templates/investigation.md` - 調査報告書テンプレート
- `docs/templates/plan.md` - 実装計画書テンプレート
- `docs/templates/project-profile.md` - `project.profile.yaml` 記述ガイド
- `docs/templates/review.md` - レビュー・検証報告書テンプレート
- `docs/templates/spec.md` - 要件仕様書テンプレート

## 4. 仕様書 (Specifications)
- `docs/specs/automation-tools-ci-integration-spec.md` - 自動化基盤 CI 連携仕様
- `docs/specs/automation-tools-design-spec.md` - 自動化基盤 設計仕様
- `docs/specs/automation-tools-implementation-spec.md` - 自動化基盤 実装仕様
- `docs/specs/framework-pilot-01-spec.md` - フレームワーク・パイロット 01 仕様
- `docs/specs/self-improvement-loop-spec.md` - 自己改善ループ仕様

## 5. 意思決定記録 (Decisions)
- `docs/decisions/20260218-ci-governance-and-task-resolution.md` - CI ガバナンスとタスク解決戦略
- `docs/decisions/20260218-self-improvement-loop-enforcement.md` - 自己改善ループの強制適用方針

## 6. 調査記録 (Investigations)
- `docs/investigations/automation-tools-ci-integration-investigation.md` - 自動化基盤 CI 連携調査
- `docs/investigations/automation-tools-implementation-investigation.md` - 自動化基盤 実装調査
- `docs/investigations/framework-pilot-01-investigation.md` - フレームワーク・パイロット 01 調査
- `docs/investigations/self-improvement-loop-investigation.md` - 自己改善ループ導入調査

## 7. 運用手順・管理 (Operations)
- `docs/operations/high-priority-backlog.md` - 高優先バックログ
- `docs/operations/framework-request-to-commit-visual-guide.md` - 要望からコミットまでのフロー可視化ガイド
- `docs/operations/ci-failure-runbook.md` - CI 失敗時の対応ランブック
- `docs/operations/runtime-framework-rules.md` - ランタイム・フレームワーク運用ルール
- `docs/operations/runtime-installation-runbook.md` - ランタイム導入ランブック
- `docs/operations/stage-terminology.md` - 開発段階の用語定義集
- `docs/operations/dq002-warning-remediation-priority-plan.md` - DQ-002 Warning Remediation Priority Plan
- `docs/operations/human-centric-doc-bank-governance.md` - Human-Centric Doc Bank Governance
- `docs/operations/human-centric-doc-bank-migration-plan.md` - Human-Centric Doc Bank Migration Plan
- `docs/operations/legacy-documents-policy.md` - 旧資料の隔離運用ポリシー
- `docs/operations/onboarding-existing-repo-document-inventory-runbook.md` - Existing Repo Onboarding: Document Inventory Runbook
- `docs/operations/onboarding-task-proposals-json-format.md` - Onboarding Task Proposals JSON Format
- `docs/operations/profile-validator-required-checks-source-of-truth.md` - Profile Validator Required Checks Source Of Truth
- `docs/operations/profile-validator-schema-version-policy.md` - Profile Validator Schema Version Policy
- `docs/operations/runtime-distribution-export-guide.md` - Runtime Distribution Export Guide
- `docs/operations/runtime-package-distribution-migration-plan.md` - Runtime Package Distribution Migration Plan
- `docs/operations/skills-framework-flow-guide.md` - Skills Framework Flow Guide
- `docs/operations/skills-sync-runbook.md` - Skills Sync Runbook
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
- `docs/operations/wave3-doc-operations-review.md` - Wave 3: Doc Operations Review
- `docs/operations/wave3-doc-quality-kpi-thresholds.md` - Wave 3: Doc Quality KPI Thresholds
- `docs/operations/wave3-doc-quality-metrics-report-automation.md` - Wave 3: Doc Quality Metrics Report Automation
- `docs/operations/wave3-kpi-process-findings-loop.md` - Wave 3: KPI Process Findings Loop
- `docs/operations/wave3-kpi-report-execution-calendar.md` - Wave 3: KPI Report Execution Calendar

## 8. インデックス更新手順

1. 資料の新規作成・名称変更を行った場合、本ファイルの適切なカテゴリに追記する。
2. 記載したパスが正しい（リンク切れがない）ことを確認する。
3. タスク完了（`done`）の前に、本ファイルの更新漏れがないか再確認する。
4. プロファイル・スキーマ変更時は `docs/operations/profile-validator-schema-version-policy.md` を優先参照すること。
