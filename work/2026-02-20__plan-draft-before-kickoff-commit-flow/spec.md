# 仕様書: 2026-02-20__plan-draft-before-kickoff-commit-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/investigation.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 理解ポイント:
  - `plan-draft` は kickoff 前に確定する探索計画であり、`plan-final` は depends_on gate pass 後に確定する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-20__plan-draft-before-kickoff-commit-flow`
- タイトル: Plan Draft Before Kickoff Commit Flow
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
- 依存タスク:
  - `2026-02-19__task-commit-boundary-automation-flow`
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-20__dependency-gate-before-plan-flow`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 固定フロー定義は `plan-draft` 先行だが、可視化資料の一部で kickoff が先に描かれており、実作業時の順序解釈にズレが生じる。
- 目的: `plan-draft` を起票境界コミット前に確定する方針を docs 上で一貫化し、運用解釈を単一化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- 可視化ガイドのフロー図を `request -> investigation -> spec -> plan-draft -> kickoff commit -> depends_on gate -> plan-final` へ修正する。
- 工程説明文で `plan-draft` 先行と kickoff 境界の関係を明示する。
- コミット境界説明で kickoff の前提が `plan-draft` 完了であることを明記する。
- 既存の固定フロー資料（`AGENTS.md`, `docs/operations/skills-framework-flow-guide.md`）との整合を確認し、必要なら補強記述を追加する。

### 3.2 Out of Scope (必須)

- commit-boundary checker のロジック改修。
- CI パイプライン定義の変更。
- subagent/multi_agent 委譲仕様の改修。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `docs/operations/framework-request-to-commit-visual-guide.md` のフロー図で `plan-draft` が kickoff commit より前に配置される。
- AC-002: 同資料の工程説明で `plan-draft` を起票前に作成することが明記される。
- AC-003: 同資料のコミット境界説明で kickoff の条件が「`request.md` / `investigation.md` / `spec.md` / `plan-draft` 完了時」と一致する。
- AC-004: `docs/operations/skills-framework-flow-guide.md` に kickoff 前提として `plan-draft` 完了を示す説明がある。
- AC-005: docs と task 資料の整合チェック（consistency/state/docs-indexer）が PASS する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: フロー順序の記述
- **検証項目**:
  - `plan-draft` が kickoff より前に記述される。
  - kickoff 条件に `plan-draft` が含まれる。
- **合格基準**: 対象 docs の該当箇所が受入条件通りに読める。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: docs 間整合
- **検証項目**:
  - `AGENTS.md`、`docs/operations/skills-framework-flow-guide.md`、可視化ガイドの順序が一致する。
  - `plan-draft` と `plan-final` の役割分離が矛盾しない。
- **合格基準**: 同一フローとして解釈できる記述のみが残る。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: framework 全体整合
- **検証項目**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-draft-before-kickoff-commit-flow`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- **合格基準**: 上記4コマンドがすべて PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. 可視化ガイドのフロー図で `plan-draft` が kickoff より前にあることを確認する。
  2. 可視化ガイドの工程説明とコミット境界説明を確認し、順序が図と一致することを確認する。
  3. skills flow guide の commit 境界説明で kickoff 前提に `plan-draft` が含まれていることを確認する。
- **期待される結果**:
  - どの資料から読んでも kickoff 前に `plan-draft` を作る運用として理解できる。

### 5.5 AC-テスト要件対応表 (必須)

- AC-001: Unit Test + Manual Verification-1
- AC-002: Unit Test + Manual Verification-2
- AC-003: Unit Test + Manual Verification-2
- AC-004: Integration Test + Manual Verification-3
- AC-005: Regression Test

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/*`
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
- 影響する仕様:
  - 固定ワークフロー
  - 2段階計画（plan-draft / plan-final）
  - コミット境界
- 非機能影響:
  - 作業順序の誤解を減らし、計画由来の手戻りを低減する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約:
  - 既存フロー（`plan-draft -> depends_on gate -> plan-final`）は維持する。
  - コミット境界は 3段階（kickoff/implementation/finalize）を維持する。
- 想定リスク:
  - 図だけ修正して本文が古いまま残ると再発する。
  - 関連資料の更新漏れで運用が分岐する。
- 回避策:
  - 図・工程説明・境界説明を同一コミットで更新する。
  - consistency/state/docs-indexer を実行して整合確認する。

## 8. 未確定事項 (Open Issues) (必須)

- なし。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
- investigation: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/investigation.md`
- plan: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/plan.md`
- review: `work/2026-02-20__plan-draft-before-kickoff-commit-flow/review.md`
- docs:
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
