# 仕様書: 2026-02-20__dependency-gate-before-plan-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
  - `work/2026-02-20__dependency-gate-before-plan-flow/investigation.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 理解ポイント:
  - 依存解決前に確定計画へ進まないため、`plan-draft` と `plan-final` を分離する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-20__dependency-gate-before-plan-flow`
- タイトル: Dependency Gate Before Plan Flow
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
- 依存タスク:
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-19__task-commit-boundary-automation-flow`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 依存未解決のまま詳細計画を確定すると、依存完了後に計画が破綻して再作成になるケースがある。
- 目的: `plan` を2段階化し、`plan-draft` は早期作成可能、`plan-final` は depends_on gate pass 後のみ確定できる運用へ変更する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- 固定フロー順序を以下に更新する。
  - `request -> investigation -> spec -> plan-draft -> depends_on gate -> plan-final -> implementation -> test -> review -> docs -> memory`
- `plan-draft` の役割と制約を定義する。
  - 依存調査・実装方針の粗い計画を保持し、commit実行や実装着手判断に使わない。
- `depends_on gate` の通過条件を「依存先 task がすべて `done`」に定義する。
- `plan-final` の確定条件を gate pass 後に限定する。
- gate fail 時の状態遷移（`blocked` 維持、先行依存タスク優先）を定義する。
- backlog と Rail10 表示に `plan-draft`, `plan-ready`, `dependency-blocked` を追加する要件を定義する。
- docs/skills/checker へ反映すべき更新範囲を定義する。

### 3.2 Out of Scope (必須)

- 依存グラフの可視化 UI 開発。
- 外部 issue tracker 連携。
- archive/legacy タスクの全面補正。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 新フロー順序に `plan-draft -> depends_on gate -> plan-final` が定義される。
- AC-002: `plan-draft` の目的・禁止事項（確定計画/実装着手/コミット判断に使わない）が定義される。
- AC-003: depends_on gate の pass/fail 判定条件が明確に定義される。
- AC-004: gate fail 時の状態遷移（`blocked` 維持、先行依存タスク優先）が定義される。
- AC-005: `plan-final` は gate pass 後のみ確定可能であるルールが定義される。
- AC-006: backlog/Rail10 に `plan-draft` / `plan-ready` / `dependency-blocked` を表示する要件が定義される。
- AC-007: docs/skills/checker の更新範囲と実装順序が定義される。
- AC-008: 実装完了時の検証手順（state/consistency/docs-indexer）が定義される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 2段階計画と depends_on gate 判定ロジック
- **検証項目**:
  - `plan-draft` の制約（確定計画として扱わない）が明示される。
  - 依存先が全て `done` の場合のみ gate pass となる。
  - 未解決依存が1件でもあれば gate fail となる。
  - gate fail の場合 `plan-final` 確定不可となる。
- **合格基準**: 正常系1件、異常系3件以上が期待どおり判定される。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: フロー順序・状態遷移・表示
- **検証項目**:
  - `spec` 後に `plan-draft` が作成される。
  - `plan-draft` 後に gate 判定が走る。
  - gate fail 時は `dependency-blocked` を表示し、`plan-final` へ進まない。
  - gate pass 後に `plan-final` 確定へ遷移できる。
- **合格基準**: 代表タスクで順序と遷移が仕様どおりに確認できる。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: framework 全体整合
- **検証項目**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- **合格基準**: 上記3コマンドがすべて PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `spec` 後に `plan-draft` を作成し、draft 制約が適用されることを確認する。
  2. 依存未解決 task で gate 判定を実行し、`plan-final` 確定が止まることを確認する。
  3. 依存先を `done` に更新して再判定し、`plan-final` 確定へ進めることを確認する。
  4. backlog と Rail10 に `plan-draft` / `dependency-blocked` / `plan-ready` が表示されることを確認する。
- **期待される結果**:
  - 依存解決前は draft まで、依存解決後のみ final 計画へ進める。

### 5.5 AC-テスト要件対応表 (必須)

- AC-001: Integration Test
- AC-002: Unit Test + Manual Verification-1
- AC-003: Unit Test
- AC-004: Integration Test + Manual Verification-2
- AC-005: Unit Test + Manual Verification-2/3
- AC-006: Integration Test + Manual Verification-4
- AC-007: Integration Test
- AC-008: Regression Test

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `AGENTS.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/high-priority-backlog.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
  - `tools/state-validate/validate.ps1`
  - `tools/consistency-check/check.ps1`
- 影響する仕様:
  - fixed workflow
  - dependency-aware prioritization
  - commit boundary automation
- 非機能影響:
  - `plan-final` 再作成の頻度低下
  - 依存待ちタスクの理由可視化向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約:
  - depends_on 判定は `work/*/state.json` の `state` を正として判断する。
  - gate pass 前に `plan-final` を確定しない。
- 想定リスク:
  - `plan-draft` と `plan-final` の使い分けが曖昧になる。
  - 表示ステータス更新漏れで運用誤解が起きる。
- 回避策:
  - `plan-draft` の禁止事項を docs/skills へ明記する。
  - backlog/Rail10/checker を同一変更単位で更新する。

## 8. 未確定事項 (Open Issues) (必須)

- なし。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__dependency-gate-before-plan-flow/request.md`
- investigation: `work/2026-02-20__dependency-gate-before-plan-flow/investigation.md`
- plan: `work/2026-02-20__dependency-gate-before-plan-flow/plan.md`
- review: `work/2026-02-20__dependency-gate-before-plan-flow/review.md`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/skills-framework-flow-guide.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
