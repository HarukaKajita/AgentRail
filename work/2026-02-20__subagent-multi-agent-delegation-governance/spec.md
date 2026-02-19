# 仕様書: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/investigation.md`
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/plan.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 理解ポイント:
  - 品質優先のため、委譲範囲を request / investigation / spec / plan-draft に限定する。

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

- 背景: subagent / multi_agent の全面委譲は速度面の利点がある一方で、品質ばらつきの懸念がある。
- 目的: request / investigation / spec / plan-draft を単一の委譲エージェントに限定して実行し、親エージェントが再検討して問題ない場合のみ kickoff と次工程およびコミットを許可する運用を確立する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 委譲対象を `request / investigation / spec / plan-draft` の4工程に限定する。
- 4工程を同一 `delegated_agent_id` で処理する契約を定義する。
- 委譲時の必須コンテキスト（task_id, delegated_agent_id, phase, objective, scope, constraints, acceptance, expected_output, editable_sections）を定義する。
- 一次成果物として `request.md / investigation.md / spec.md / plan.md(plan-draft)` を直接更新する規約を定義する。
- sidecar 監査ログ保存先と記録項目を定義する。
- 親再検討ゲート（`gate_result=pass|fail`）と進行可否を定義する。
- 親ゲート `pass` 前は kickoff と `depends_on gate` / `plan-final` 着手およびコミットを禁止するルールを定義する。

### 3.2 Out of Scope [空欄禁止]

- `depends_on gate / plan-final / test / review / docs_update` の委譲標準化。
- 複数サブエージェントの並列分担運用。
- CI への新規自動検査導入。
- subagent 実行インフラそのものの改修。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 委譲範囲が `request / investigation / spec / plan-draft` のみに限定されている。
- AC-002: 4工程を同一 `delegated_agent_id` で処理する実行契約が定義されている。
- AC-003: 委譲必須コンテキスト項目（task_id, delegated_agent_id, phase, objective, scope, constraints, acceptance, expected_output, editable_sections）が定義されている。
- AC-004: 一次成果物更新先（`request.md / investigation.md / spec.md / plan.md(plan-draft)`）と sidecar 監査ログ規約が定義されている。
- AC-005: 親再検討時の返却フォーマットと再検証項目が定義されている。
- AC-006: `gate_result=pass` 前は kickoff と次工程（`depends_on gate` / `plan-final`）およびコミットを禁止し、`fail` では差し戻しとなるルールが定義されている。
- AC-007: 親固定工程（`depends_on gate / plan-final / test / review / docs_update / commit`）が定義されている。
- AC-008: 実装時に更新すべき docs と skill ファイル範囲が明示されている。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 委譲仕様（範囲、単一エージェント契約、ゲート契約）
- 観点:
  - 委譲対象が 4工程に限定されている。
  - 単一 `delegated_agent_id` 契約が定義されている。
  - 必須コンテキスト項目が欠落なく列挙されている。
  - `gate_result=pass` 前の kickoff / depends_on gate / plan-final 進行禁止が明示されている。
- 合格条件: 仕様文書中に各定義が欠落なく存在する。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: task 文書間の整合
- 観点:
  - request / investigation / spec / plan-draft の用語が「4工程限定委譲 + 親再検討」で整合する。
  - 親固定工程の定義が plan-final 以降と矛盾しない。
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
  1. 単一 `delegated_agent_id` で request -> investigation -> spec -> plan-draft を連続実行する。
  2. `request.md / investigation.md / spec.md / plan.md(plan-draft)` が更新され、sidecar 監査ログが残ることを確認する。
  3. 親再検討で `gate_result=fail` を記録し、kickoff / depends_on gate / plan-final とコミットが禁止されることを確認する。
  4. 親再検討で `gate_result=pass` を記録し、kickoff / depends_on gate / plan-final とコミットが許可されることを確認する。
- 期待結果:
  - 品質ゲート結果に応じて遷移可否が一意に決まる。

### 5.5 AC-テスト要件対応表 [空欄禁止]

- AC-001: Unit Test
- AC-002: Unit Test + Manual Verification-1
- AC-003: Unit Test
- AC-004: Unit Test + Manual Verification-2
- AC-005: Unit Test
- AC-006: Unit Test + Manual Verification-3/4
- AC-007: Unit Test + Integration Test
- AC-008: Integration Test + Regression Test

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `AGENTS.md`（必要時）
  - `.agents/skills/**/SKILL.md`（実装段階）
  - `agents/skills/**/SKILL.md`（実装段階）
  - `work/2026-02-20__subagent-multi-agent-delegation-governance/*`
- 影響する仕様:
  - fixed workflow
  - commit boundaries
  - dependency gate
- 非機能影響:
  - 品質確認強化によりスループットは一部低下する可能性がある。
  - 4工程の草案生成は委譲により初動速度を維持できる。

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 委譲対象は request / investigation / spec / plan-draft のみ。
  - 4工程は同一 `delegated_agent_id` で処理する。
  - `depends_on gate` 以降とコミットは親固定。
- 想定リスク:
  - 単一委譲でボトルネックが発生する。
  - コンテキスト不足で4工程すべてに誤りが波及する。
- 回避策:
  - 親の再検討チェックリストを固定化する。
  - `gate_result=fail` で即時差し戻しし、次工程とコミットを停止する。

## 8. 委譲実行契約 [空欄禁止]

### 8.1 工程別オーナー契約 (Phase Ownership Matrix) [空欄禁止]

| phase | owner | rule |
| --- | --- | --- |
| request | delegated agent | 同一 `delegated_agent_id` で実行 |
| investigation | delegated agent | 同一 `delegated_agent_id` で実行 |
| spec | delegated agent | 同一 `delegated_agent_id` で実行 |
| plan-draft | delegated agent | 同一 `delegated_agent_id` で実行 |
| depends_on gate | parent agent | 委譲禁止（親固定） |
| plan-final | parent agent | 委譲禁止（親固定） |
| test | parent agent | 委譲禁止（親固定） |
| review | parent agent | 委譲禁止（親固定） |
| docs_update | parent agent | 委譲禁止（親固定） |
| commit | parent agent | 委譲禁止（親固定） |

### 8.2 委譲入力コンテキスト契約 [空欄禁止]

- 必須キー:
  - `task_id`
  - `delegated_agent_id`
  - `phase`
  - `objective`
  - `scope`
  - `constraints`
  - `acceptance`
  - `expected_output`
  - `editable_sections`

### 8.3 一次成果物と sidecar 監査ログ契約 [空欄禁止]

- 一次成果物:
  - `work/<task-id>/request.md`
  - `work/<task-id>/investigation.md`
  - `work/<task-id>/spec.md`
  - `work/<task-id>/plan.md`（`plan-draft` 節）
- sidecar 保存先規約:
  - `work/<task-id>/agent-logs/<phase>/<timestamp>-<delegated-agent-id>.md`
- sidecar 必須項目:
  - `parent_agent_id`
  - `delegated_agent_id`
  - `phase`
  - `target_md_path`
  - `commands_executed`
  - `summary`
  - `changed_files`
  - `open_risks`

### 8.4 親返却フォーマットと再検討契約 [空欄禁止]

- 必須キー:
  - `phase`
  - `target_md_path`
  - `edited_sections`
  - `summary`
  - `evidence_commands`
  - `changed_files`
  - `open_risks`
  - `needs_decision`
  - `sidecar_log_path`
- 親再検討チェック:
  - 返却 `edited_sections` と実差分の一致確認
  - `evidence_commands` の再実行または同等検証
  - 要件逸脱有無の確認

### 8.5 ゲート・遷移・コミット契約 [空欄禁止]

- 親は `plan-draft` 確定後に `gate_result`（`pass` or `fail`）を記録する。
- `gate_result=pass` まで kickoff commit を禁止する。
- `gate_result=pass` まで `depends_on gate` と `plan-final` 着手を禁止する。
- `gate_result=pass` まで `git commit` を禁止する。
- `gate_result=fail` は差し戻しとし、`state.json` の `state` は `blocked` または `in_progress` の範囲で維持する。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__subagent-multi-agent-delegation-governance/request.md`
- investigation: `work/2026-02-20__subagent-multi-agent-delegation-governance/investigation.md`
- plan: `work/2026-02-20__subagent-multi-agent-delegation-governance/plan.md`
- review: `work/2026-02-20__subagent-multi-agent-delegation-governance/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`

## 10. 未確定事項 [空欄禁止]

- なし。
