# 仕様書: 2026-02-18__docs-indexer-check-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__docs-indexer-check-mode`
- タイトル: docs-indexer check モード追加
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__docs-indexer-check-mode/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: `docs-indexer` は常に書き込みを伴う。
- 目的: CI 用の非破壊検証モードを導入して差分判定を明確化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/docs-indexer/index.ps1` に `-Mode apply|check` を追加
- `check` でファイル非更新 + 差分判定
- CI workflow の呼び出し更新

### 3.2 Out of Scope (必須)

- docs-indexer の対象カテゴリ追加
- consistency-check の仕様変更

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `apply` 既存挙動を維持する
- AC-002: `check` で差分なしは 0、差分ありは 1
- AC-003: `check` は `docs/INDEX.md` を書き換えない
- AC-004: CI が `check` モード利用に切り替わる

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: モード分岐
- **検証項目**: `apply` / `check` の分岐精度
- **合格基準**: モードごとに期待動作

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: workflow 連携
- **検証項目**: `check` の終了コード伝播
- **合格基準**: 差分時にCI失敗

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 apply 運用
- **検証項目**: 既存 docs 更新が維持される
- **合格基準**: 従来手順が成立

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `apply` 実行
  2. `check` 実行
  3. CI の step 構成確認
- **期待される結果**: AC-001〜AC-004 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/docs-indexer/index.ps1`
  - `.github/workflows/ci-framework.yml`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 非機能影響:
  - CI 判定の明確性向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: PowerShell 実装を維持
- 想定リスク: `check` と `apply` の判定不一致
- 回避策: 生成ロジックを共通化して比較のみ分離

## 8. 未確定事項 (Open Issues) (必須)

- `check` モード出力の詳細レベル

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__docs-indexer-check-mode/request.md`
- investigation: `work/2026-02-18__docs-indexer-check-mode/investigation.md`
- plan: `work/2026-02-18__docs-indexer-check-mode/plan.md`
- review: `work/2026-02-18__docs-indexer-check-mode/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
