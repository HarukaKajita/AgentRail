# 仕様書: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/investigation.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 理解ポイント:
  - 固定ワークフローを維持しつつ、subagent / multi_agent を標準活用する設計を行う。

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-20__subagent-multi-agent-delegation-governance`
- タイトル: Subagent Multi-Agent Delegation Governance
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
- 依存タスク:
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-19__task-commit-boundary-automation-flow`
  - `2026-02-19__task-doc-prerequisite-knowledge-section`

## 2. 背景と目的 [空欄禁止]

- 背景: 既存スキル運用は固定工程を定義済みだが、subagent / multi_agent 利用の標準手順が不明確。
- 目的: 各工程での委譲方針、例外工程、成果物記録、親エージェント品質ゲートを統一し、再現可能な運用へ改善する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 委譲対象工程の標準化（request / investigation / spec / plan / docs update / test 実行）。
- 例外工程の明確化（親エージェント固定）。
- subagent へ渡す必須コンテキスト定義。
- 工程 md への記録フォーマット（Subagent Worklog）定義。
- 親エージェントへ返却する最小情報セット定義。
- 親側の再検証ルール（品質ゲート）定義。
- `docs/operations/skills-framework-flow-guide.md` と関連運用 docs への反映方針。

### 3.2 Out of Scope [空欄禁止]

- 全スキル実装の同時改修完了。
- CI への新規自動検査導入。
- subagent 実行インフラそのものの改修。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 委譲対象工程と例外工程が工程別マトリクスで定義される。
- AC-002: subagent へ渡す必須コンテキスト項目（task_id, phase, objective, scope, constraints, acceptance, expected_output）が定義される。
- AC-003: 工程 md に記録する `Subagent Worklog` セクション仕様が定義される。
- AC-004: 親エージェント返却フォーマット（変更ファイル、実行コマンド、結果、未解決リスク、推奨次アクション）が定義される。
- AC-005: 親側品質ゲート（再検証必須、高リスク工程の親固定、不一致時差し戻し）が定義される。
- AC-006: 実装時に更新すべき docs と skill ファイル範囲が明示される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 委譲仕様（工程マトリクス、コンテキスト定義、返却定義）
- 観点:
  - 例外工程が親固定として明示される。
  - コンテキスト項目が不足なく列挙される。
  - 返却フォーマットが機械的に確認可能な粒度で記載される。
- 合格条件: 仕様文書中に各定義が欠落なく存在する。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 運用 docs と task 文書の整合
- 観点:
  - `skills-framework-flow-guide` に委譲方針と例外規則が反映される。
  - task の request/investigation/spec/plan/review が同一用語で整合する。
- 合格条件: 整合チェックで矛盾が検出されない。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: framework 全体整合
- 観点:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- 合格条件: 上記3コマンドがすべて PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 低リスク工程（例: investigation）で委譲手順が完結することを確認する。
  2. 高リスク工程（例: 最終受入判定）で親固定ルールが適用されることを確認する。
  3. Subagent Worklog から親返却情報まで追跡可能であることを確認する。
- 期待結果:
  - 委譲可能工程と例外工程の挙動差が明確に説明できる。

### 5.5 AC-テスト要件対応表 [空欄禁止]

- AC-001: Unit Test + Manual Verification-1/2
- AC-002: Unit Test
- AC-003: Unit Test + Manual Verification-3
- AC-004: Unit Test + Manual Verification-3
- AC-005: Unit Test + Manual Verification-2
- AC-006: Integration Test + Regression Test

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `AGENTS.md`（必要時）
  - `.agents/skills/**/SKILL.md`（実装段階）
  - `agents/skills/**/SKILL.md`（実装段階）
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/*`
- 影響する仕様:
  - fixed workflow, commit boundaries, dependency gate
- 非機能影響:
  - 並列化による作業速度向上
  - 親再検証ステップ追加によるレビュー負荷増

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 高リスク工程は親エージェント固定とする。
  - 委譲時は工程 md へのログ記録を必須とする。
- 想定リスク:
  - サブエージェントへのコンテキスト不足で品質低下が起きる。
  - 返却情報の粒度不足で親の再検証が困難になる。
- 回避策:
  - コンテキスト必須項目を固定し、不足時は blocked 扱いにする。
  - 親側で再検証コマンド実行を必須化する。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
- investigation: `work/2026-02-20__subagent-multi-agent-delegation-governance/investigation.md`
- plan: `work/2026-02-20__subagent-multi-agent-delegation-governance/plan.md`
- review: `work/2026-02-20__subagent-multi-agent-delegation-governance/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
