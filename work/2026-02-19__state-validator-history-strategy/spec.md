# 仕様書: 2026-02-19__state-validator-history-strategy

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__state-validator-history-strategy`
- タイトル: State Validator History Strategy
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__state-validator-history-strategy/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: state history の保存場所が未定義で、将来 `state.json` へ履歴を積むか外部化するかの方針が曖昧だった。
- 目的: state history 管理方式を決定し、validator で方針逸脱を検知できる状態にする。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- state history 方式を「外部化（Git 履歴）」に決定する。
- `tools/state-validate/validate.ps1` へ `history`/`state_history` キー禁止チェックを追加する。
- 運用 docs に履歴参照手順を記録し、backlog 状態を更新する。

### 3.2 Out of Scope [空欄禁止]

- 専用 state history ストアの新規実装。
- 既存 task 履歴の再構築。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: state history 方針が docs で「Git 履歴外部化」に決定されている。
- AC-002: `tools/state-validate/validate.ps1` が `history` または `state_history` キーを含む `state.json` を FAIL する。
- AC-003: 現在のリポジトリで `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` が PASS する。
- AC-004: high-priority / validator backlog と task 記録が更新される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/state-validate/validate.ps1`
- 観点: `state.json` の禁止キー検知（`history` / `state_history`）が機能する。
- 合格条件: 禁止キーありで FAIL、禁止キーなしで PASS。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `tools/state-validate/validate.ps1 -AllTasks`
- 観点: 全 task 検証で既存運用が維持される。
- 合格条件: `STATE_VALIDATE: PASS` が出力される。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: `tools/consistency-check/check.ps1` と `tools/docs-indexer/index.ps1`
- 観点: task 文書/docs 更新後の既存品質ゲートが PASS する。
- 合格条件: consistency-check と docs-indexer check が PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` を実行する。
  2. 一時 `state.json` に `history` キーを追加した task を作成し、`tools/state-validate/validate.ps1 -TaskId <task> -WorkRoot <temp-work>` を実行する。
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__state-validator-history-strategy` を実行する。
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` を実行する。
- 期待結果: 手順1/3/4は PASS、手順2は `state history must be externalized` を含んで FAIL。

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/state-validate/validate.ps1`
  - `docs/operations/state-history-strategy.md`（新規）
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
- 影響する仕様:
  - `docs/operations/validator-enhancement-backlog.md`
- 非機能影響:
  - state.json の肥大化抑制と履歴運用の一貫性向上。

## 7. 制約とリスク [空欄禁止]

- 制約: 既存 `state.json` 最小キー運用を維持する。
- 想定リスク: 履歴を state.json に持ちたいケースとの方針衝突。
- 回避策: history 要求が出た場合は専用 artifact 方針を別タスクで設計し、本ルールを更新する。

## 8. 未確定事項 [空欄禁止]

- Git 以外の履歴ストア採用基準。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__state-validator-history-strategy/request.md`
- investigation: `work/2026-02-19__state-validator-history-strategy/investigation.md`
- plan: `work/2026-02-19__state-validator-history-strategy/plan.md`
- review: `work/2026-02-19__state-validator-history-strategy/review.md`
- docs:
  - `docs/operations/state-history-strategy.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
