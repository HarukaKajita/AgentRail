# 仕様書: 2026-02-18__self-improvement-loop-enforcement

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__self-improvement-loop-enforcement`
- タイトル: 自己改善ループ強制の実装
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__self-improvement-loop-enforcement/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: review の改善知見が task 化されず、資料更新漏れの再発リスクが残っていた。
- 目的: must-high finding の未起票を CI で確実に検知し、自己改善ループを運用フローへ組み込む。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `review.md` Process Findings スキーマの導入
- findings 検証/抽出 CLI 追加
- follow-up task 自動起票 CLI 追加
- consistency-check/CI への改善ゲート追加
- docs/operations/templates 更新

### 3.2 Out of Scope [空欄禁止]

- 外部Issue管理ツール連携
- 複数 task 同時変更のCI判定方式の全面改修

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `review.md` に Process Findings 必須ルールを導入できる。
- AC-002: `tools/improvement-harvest/scan.ps1` が findings を検証・抽出できる。
- AC-003: `tools/improvement-harvest/create-task.ps1` が follow-up task の必須6ファイルを生成できる。
- AC-004: `tools/consistency-check/check.ps1` が must-high 未起票を FAIL できる。
- AC-005: CI が `tools/improvement-harvest/scan.ps1` と拡張 checker により未起票をブロックできる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/improvement-harvest/scan.ps1` と `tools/consistency-check/check.ps1` の finding バリデーション
- 観点: required key / severity / action_required / linked_task_id の判定
- 合格条件: 不正入力で FAIL、正しい入力で PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `.github/workflows/ci-framework.yml` と改善ゲート
- 観点: resolve task 後に scan/check が連続実行される
- 合格条件: finding 不備時に CI が FAIL する

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: docs-indexer と既存 consistency ルール
- 観点: 新ルール導入後も既存ルールが機能する
- 合格条件: 対象 task の consistency-check が PASS する

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId 2026-02-18__self-improvement-loop-enforcement`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__self-improvement-loop-enforcement`
  3. `pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId 2026-02-18__self-improvement-loop-enforcement -FindingId F-001 -Title "Sample Follow Up" -Severity high -Category flow -WorkRoot <temp-dir>`
- 期待結果: AC-001〜AC-005 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `tools/improvement-harvest/scan.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/templates/review.md`
- 影響する仕様:
  - `docs/specs/phase2-automation-spec.md`
  - `docs/specs/phase2-ci-integration-spec.md`
- 非機能影響:
  - 改善漏れ再発防止
  - レビュー知見のトレーサビリティ向上

## 7. 制約とリスク [空欄禁止]

- 制約: 追加依存を入れず PowerShell で完結する。
- 想定リスク: 既存 task の review 書式が新ルール未対応。
- 回避策: 新規/更新 task から段階適用し、必要時に既存 task を順次移行する。

## 8. 未確定事項 [空欄禁止]

- `medium` の mandatory 化を将来フェーズで行うか。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__self-improvement-loop-enforcement/request.md`
- investigation: `work/2026-02-18__self-improvement-loop-enforcement/investigation.md`
- plan: `work/2026-02-18__self-improvement-loop-enforcement/plan.md`
- review: `work/2026-02-18__self-improvement-loop-enforcement/review.md`
- docs:
  - `docs/specs/self-improvement-loop-spec.md`
  - `docs/investigations/self-improvement-loop-investigation.md`
  - `docs/decisions/20260218-self-improvement-loop-enforcement.md`
  - `docs/operations/ci-failure-runbook.md`
