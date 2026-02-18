# 仕様書: 2026-02-18__automation-tools-implementation

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__automation-tools-implementation`
- タイトル: 自動化基盤段階 自動化実装（docs-indexer / consistency-check）
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__automation-tools-implementation/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: 自動化基盤段階の設計は完了しているが、実装が未着手。
- 目的: 手動運用を補助する自動化スクリプトを導入し、整合性検査を機械化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/docs-indexer/index.ps1` の実装
- `tools/consistency-check/check.ps1` の実装
- `project.profile.yaml` へのコマンド追加
- `docs/specs/automation-tools-design-spec.md` の確定内容反映
- docs と work 資料更新

### 3.2 Out of Scope [空欄禁止]

- CI ワークフロー実装
- checker の task ID 自動推定
- multi-platform 向け追加ランタイム導入

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `docs-indexer` が `docs/INDEX.md` の管理セクションを更新できる。
- AC-002: `docs-indexer` を連続実行して差分が発生しない。
- AC-003: `consistency-check` が PASS/FAIL と詳細、終了コードを返せる。
- AC-004: `check.ps1 -TaskId 2026-02-18__automation-tools-implementation` が PASS する。
- AC-005: `project.profile.yaml` に `index_docs` と `check_consistency` が追加されている。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 各スクリプトの入力検証と失敗条件
- 観点: 必須ファイル欠落時の失敗、見出し欠落時の失敗
- 合格条件: 想定失敗で Exit Code 1 を返す

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: docs-indexer と docs/INDEX.md の連携
- 観点: 管理セクション更新と手動セクション保持
- 合格条件: セクション `## 2`〜`## 5` が正しく更新され、`## 1` と `## 6` は保たれる

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 task `2026-02-18__framework-pilot-01`
- 観点: checker 適用で既存ドキュメント運用を壊さない
- 合格条件: `check.ps1 -TaskId 2026-02-18__framework-pilot-01` が PASS する

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1` を実行
  2. 再実行して差分がないことを確認
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-implementation` を実行
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01` を実行
- 期待結果: すべて PASS、終了コード 0

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/docs-indexer/index.ps1`
  - `tools/consistency-check/check.ps1`
  - `project.profile.yaml`
  - `docs/INDEX.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `work/2026-02-18__automation-tools-implementation/*`
- 影響する仕様:
  - `docs/specs/automation-tools-design-spec.md`
- 非機能影響:
  - 手動更新工数が削減される

## 7. 制約とリスク [空欄禁止]

- 制約: PowerShell のみで実装する
- 想定リスク: Markdown の記法揺れで解析失敗する可能性
- 回避策: 見出し・リンク形式のルールを docs に明示し、失敗時は詳細を出力する

## 8. 未確定事項 [空欄禁止]

- CI 実行時に `<task-id>` をどう渡すか

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__automation-tools-implementation/request.md`
- investigation: `work/2026-02-18__automation-tools-implementation/investigation.md`
- plan: `work/2026-02-18__automation-tools-implementation/plan.md`
- review: `work/2026-02-18__automation-tools-implementation/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-implementation-spec.md`
  - `docs/investigations/automation-tools-implementation-investigation.md`
