# 仕様書: 2026-02-18__automation-tools-ci-integration

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__automation-tools-ci-integration`
- タイトル: 自動化基盤 CI 連携
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__automation-tools-ci-integration/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `docs-indexer` と `consistency-check` は実装済みだが、CI への統合は未実施。
- 目的: GitHub Actions で自動実行し、INDEX 更新漏れと整合性崩れを PR / push 時点で検知する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `.github/workflows/ci-framework.yml` の追加
- latest task-id 自動解決 step の導入
- `docs-indexer` 実行後の INDEX 差分検知
- `check_consistency` 実行
- docs および work 資料更新

### 3.2 Out of Scope [空欄禁止]

- CI からの自動コミット
- 複数 CI プラットフォーム対応
- checker の JSON 出力対応

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `.github/workflows/ci-framework.yml` が追加され、`push` / `pull_request` で起動する。
- AC-002: CI が `docs-indexer` を実行し、`docs/INDEX.md` 差分がある場合に失敗する。
- AC-003: CI が `work/` から最新 task-id を一意に解決し、解決不能なら失敗する。
- AC-004: CI が `check_consistency` を実行し、FAIL 時にジョブが失敗する。
- AC-005: CI 連携内容が `docs/specs/automation-tools-design-spec.md` と `docs/INDEX.md` に反映される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: workflow 内の task-id 解決ロジック
- 観点: `work/` 空時と同時刻競合時の失敗動作
- 合格条件: 解決不能時はエラー終了する

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `docs-indexer` + INDEX差分判定 + `check_consistency`
- 観点: CI 手順の直列実行と失敗伝播
- 合格条件: いずれか失敗時にジョブ全体が失敗する

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 task（framework pilot / automation implementation）
- 観点: checker 適用で既存ドキュメント運用が崩れないか
- 合格条件: `tools/consistency-check/check.ps1` が両 task で PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1` を実行
  2. `git diff --exit-code -- docs/INDEX.md` を実行
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-ci-integration` を実行
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-implementation` を実行
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01` を実行
- 期待結果: すべて PASS、終了コード 0

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/investigations/automation-tools-ci-integration-investigation.md`
  - `docs/INDEX.md`
  - `MEMORY.md`
  - `work/2026-02-18__automation-tools-ci-integration/*`
- 影響する仕様:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-implementation-spec.md`
- 非機能影響:
  - PR時に整合チェックが自動化され、手動レビュー負荷が低下する

## 7. 制約とリスク [空欄禁止]

- 制約: GitHub Actions を CI 基盤として採用する
- 想定リスク: `LastWriteTime` 同率時に task-id 解決不能となる
- 回避策: 同率時は失敗させ、明示的に task 更新を行って再実行する

## 8. 未確定事項 [空欄禁止]

- checker の対象を最新1件から複数件に拡張するかどうか

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__automation-tools-ci-integration/request.md`
- investigation: `work/2026-02-18__automation-tools-ci-integration/investigation.md`
- plan: `work/2026-02-18__automation-tools-ci-integration/plan.md`
- review: `work/2026-02-18__automation-tools-ci-integration/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/investigations/automation-tools-ci-integration-investigation.md`
