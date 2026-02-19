# 仕様書: 2026-02-19__state-validator-done-docs-index-consistency

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__state-validator-done-docs-index-consistency`
- タイトル: State Validator Done Docs Index Consistency
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__state-validator-done-docs-index-consistency/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: source finding では、`state=done` 判定が review 整合中心で、docs/INDEX 反映整合まで担保できていない点が指摘された。
- 目的: state validator の done 判定に docs/INDEX 整合チェックを追加し、done 状態の品質ゲートを強化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/state-validate/validate.ps1` に docs/INDEX 整合判定を追加する。
- `state=done` の task で spec docs path の存在と `docs/INDEX.md` 収録を検証する。
- 運用 docs と backlog 状態を更新する。

### 3.2 Out of Scope [空欄禁止]

- `tools/consistency-check/check.ps1` との実装共通化。
- `state history` 管理方式の決定（VE-004 で対応）。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `tools/state-validate/validate.ps1` が `state=done` 時に spec docs path と `docs/INDEX.md` の整合を検証する。
- AC-002: docs path が index 未反映の done task を検証したとき、state validator が FAIL する。
- AC-003: 現在のリポジトリ状態で `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` が PASS する。
- AC-004: 追加した検証ルールが docs に記録され、backlog 状態と task 記録が更新される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/state-validate/validate.ps1`
- 観点: spec docs path 抽出と `docs/INDEX.md` 収録確認が done 条件で機能する。
- 合格条件: 正常 index では PASS、index 未反映ケースでは FAIL する。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `tools/state-validate/validate.ps1 -AllTasks`
- 観点: 既存 task 群を対象に done 条件追加後も全体検証が成立する。
- 合格条件: `STATE_VALIDATE: PASS` が出力される。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: `tools/consistency-check/check.ps1`
- 観点: task 文書更新後も consistency-check の必須ルールが PASS する。
- 合格条件: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__state-validator-done-docs-index-consistency` が PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` を実行する。
  2. 一時ディレクトリに done task と `docs/INDEX.md` をコピーし、対象 docs path を index から削除して `tools/state-validate/validate.ps1 -TaskId <task> -WorkRoot <temp-work> -DocsIndexPath <temp-index>` を実行する。
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__state-validator-done-docs-index-consistency` を実行する。
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` を実行する。
- 期待結果: 手順1/3/4は PASS、手順2は `state=done requires docs/INDEX.md to include docs path` を含んで FAIL。

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/state-validate/validate.ps1`
  - `docs/operations/state-validator-done-docs-index-consistency.md`（新規）
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
- 影響する仕様:
  - `docs/operations/validator-enhancement-backlog.md`
- 非機能影響:
  - done 状態の運用品質が向上し、docs 反映漏れを早期検知できる。

## 7. 制約とリスク [空欄禁止]

- 制約: 既存 task 文書のフォーマット（spec 9章 docs リンク）と互換を保つ。
- 想定リスク: docs path 抽出パターンの揺れで誤検知する可能性。
- 回避策: 抽出規則を `docs/...` の backtick パスに限定し、正常系・異常系を review へ記録する。

## 8. 未確定事項 [空欄禁止]

- state validator と consistency-check の docs 判定ロジック共通化タイミング。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__state-validator-done-docs-index-consistency/request.md`
- investigation: `work/2026-02-19__state-validator-done-docs-index-consistency/investigation.md`
- plan: `work/2026-02-19__state-validator-done-docs-index-consistency/plan.md`
- review: `work/2026-02-19__state-validator-done-docs-index-consistency/review.md`
- docs:
  - `docs/operations/state-validator-done-docs-index-consistency.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
