# 仕様書: 2026-02-19__task-dependency-aware-prioritization-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__task-dependency-aware-prioritization-flow`
- タイトル: Dependency-Aware Task Prioritization Flow
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__task-dependency-aware-prioritization-flow/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: 現行フレームワークは planned タスクの優先度表示を持つが、タスク依存関係を保持・検証・表示する標準機能がない。
- 目的: 起票時と着手時に依存関係を扱うフローを標準化し、先行完了が必要なタスクを自動的に優先できる運用へ改善する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 依存関係データモデルを定義する。
  - `work/<task-id>/state.json` に依存先 task-id 配列を追加する仕様。
  - `docs/operations/high-priority-backlog.md` に依存関係表示欄を追加する仕様。
- 起票時フローを定義する。
  - 起票時に依存関係調査を必須化する。
  - 依存先 task が不足している場合の追加起票ルールを定義する。
- 着手時フローを定義する。
  - 着手対象 task の依存解決確認を必須化する。
  - 未解決依存がある場合は依存先 task を先行着手対象として提示するルールを定義する。
- 可視化と表示を定義する。
  - high-priority backlog で依存状態（なし/未解決/解決済み）を表示する。
  - Rail10 スキルと付属スクリプトで依存状態を表示し、着手候補を依存解決済み優先で提示する。
- 検証ルールを定義する。
  - state validator / consistency-check の依存関係検証要件を定義する。
  - 依存循環、自己依存、不存在 task 参照の失敗条件を定義する。

### 3.2 Out of Scope [空欄禁止]

- タスク依存関係を GUI で編集する新規ツール開発。
- archive 配下の過去タスクを一括で完全補正すること。
- 外部 issue tracker との同期連携。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 依存関係フィールド（state/backlog）の標準仕様が定義される。
- AC-002: 起票時依存調査と不足依存先の追加起票ルールが定義される。
- AC-003: 着手時依存ゲート（依存未解決時の先行タスク優先）が定義される。
- AC-004: backlog と Rail10 表示に依存関係情報を出す要件が定義される。
- AC-005: validator/checker による依存関係検証要件（循環・不存在・自己依存検知）が定義される。
- AC-006: docs/skills/workflow の更新範囲と完了判定が定義される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 依存関係判定ロジック（依存解決判定、循環検知、自己依存検知）
- 観点:
  - 依存先すべて done の場合は ready 判定になる。
  - 依存先未完了が1つでもある場合は blocked-by-dependency 判定になる。
  - 循環依存と自己依存を FAIL 判定できる。
- 合格条件: 正常系1ケース、異常系3ケース以上が期待どおりに判定される。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 起票フローと着手フロー
- 観点:
  - 起票時に依存調査結果が task 文書と state に反映される。
  - 着手時に依存未解決なら先行タスクが提示され、対象タスクは着手抑止される。
  - 依存解決後に着手可能へ遷移する。
- 合格条件: モック task セットで起票→着手判定が仕様どおり遷移する。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 task 運用（backlog 表示、Rail10 出力、state/consistency 検証）
- 観点:
  - 依存なし task は従来どおり表示・進行できる。
  - backlog と Rail10 の整合警告が既存運用を壊さない。
  - 全 task 検証で過剰 FAIL が発生しない移行方針がある。
- 合格条件:
  - `tools/state-validate/validate.ps1 -AllTasks` PASS
  - `tools/consistency-check/check.ps1 -AllTasks` PASS
  - Rail10 スクリプト出力が依存情報追加後も実行可能

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 依存先あり task と依存先なし task を用意し、backlog と Rail10 表示を比較する。
  2. 依存先未完了状態で着手判定を実行し、先行タスクへ誘導されることを確認する。
  3. 依存先を done に更新後、元タスクが着手可能になることを確認する。
  4. 循環依存・不存在依存を設定し、validator/checker が明確に FAIL することを確認する。
- 期待結果: 依存関係を含む優先制御が仕様どおりに動作し、表示と検証が一致する。

### 5.5 AC-テスト対応表 [空欄禁止]

- AC-001: Unit Test + Manual Verification-1
- AC-002: Integration Test
- AC-003: Integration Test + Manual Verification-2/3
- AC-004: Regression Test + Manual Verification-1
- AC-005: Unit Test + Manual Verification-4
- AC-006: Regression Test + Manual Verification-1/4

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/state-validate/validate.ps1`
  - `tools/consistency-check/check.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `work/*/state.json`
- 影響する仕様:
  - task 起票運用
  - task 着手運用
  - planned タスク優先表示運用
- 非機能影響:
  - 着手順序の再現性向上
  - 手戻り削減
  - 運用透明性向上

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 依存先識別子は task-id のみを許容する。
  - 依存判定はローカル `work/` と backlog 情報で完結させる。
- 想定リスク:
  - 依存循環で着手不能タスクが増える。
  - 既存 task に依存項目追加時の移行コストが発生する。
  - backlog と state の依存情報不一致が発生する。
- 回避策:
  - 循環検知と明確なエラーメッセージを追加する。
  - 既存 task には段階移行ルールを設ける。
  - backlog/state の相互整合チェックを検証ルールに含める。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__task-dependency-aware-prioritization-flow/request.md`
- investigation: `work/2026-02-19__task-dependency-aware-prioritization-flow/investigation.md`
- plan: `work/2026-02-19__task-dependency-aware-prioritization-flow/plan.md`
- review: `work/2026-02-19__task-dependency-aware-prioritization-flow/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
