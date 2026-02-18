# 仕様書: 2026-02-18__docs-indexer-check-mode

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__docs-indexer-check-mode`
- タイトル: docs-indexer check モード追加
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__docs-indexer-check-mode/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `docs-indexer` は常に書き込みを伴う。
- 目的: CI 用の非破壊検証モードを導入して差分判定を明確化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/docs-indexer/index.ps1` に `-Mode apply|check` を追加
- `check` でファイル非更新 + 差分判定
- CI workflow の呼び出し更新

### 3.2 Out of Scope [空欄禁止]

- docs-indexer の対象カテゴリ追加
- consistency-check の仕様変更

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `apply` 既存挙動を維持する
- AC-002: `check` で差分なしは 0、差分ありは 1
- AC-003: `check` は `docs/INDEX.md` を書き換えない
- AC-004: CI が `check` モード利用に切り替わる

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: モード分岐
- 観点: `apply` / `check` の分岐精度
- 合格条件: モードごとに期待動作

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: workflow 連携
- 観点: `check` の終了コード伝播
- 合格条件: 差分時にCI失敗

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 apply 運用
- 観点: 既存 docs 更新が維持される
- 合格条件: 従来手順が成立

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `apply` 実行
  2. `check` 実行
  3. CI の step 構成確認
- 期待結果: AC-001〜AC-004 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/docs-indexer/index.ps1`
  - `.github/workflows/ci-framework.yml`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 非機能影響:
  - CI 判定の明確性向上

## 7. 制約とリスク [空欄禁止]

- 制約: PowerShell 実装を維持
- 想定リスク: `check` と `apply` の判定不一致
- 回避策: 生成ロジックを共通化して比較のみ分離

## 8. 未確定事項 [空欄禁止]

- `check` モード出力の詳細レベル

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__docs-indexer-check-mode/request.md`
- investigation: `work/2026-02-18__docs-indexer-check-mode/investigation.md`
- plan: `work/2026-02-18__docs-indexer-check-mode/plan.md`
- review: `work/2026-02-18__docs-indexer-check-mode/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
