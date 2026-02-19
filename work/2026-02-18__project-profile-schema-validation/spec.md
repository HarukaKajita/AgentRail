# 仕様書: 2026-02-18__project-profile-schema-validation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__project-profile-schema-validation`
- タイトル: project.profile.yaml スキーマ検証
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__project-profile-schema-validation/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: profile 検証が checker に分散し、原因特定がしづらい。
- 目的: profile 専用 validator を導入して早期失敗させる。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/profile-validate/validate.ps1` 追加
- 必須キー検証と禁止値検証
- CI への組み込み

### 3.2 Out of Scope [空欄禁止]

- profile フォーマット刷新
- checker ルール全面再設計

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 必須キー欠落で FAIL
- AC-002: `TODO_SET_ME` 残存で FAIL
- AC-003: 正常 profile で PASS
- AC-004: CI で validator が実行される

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 必須キー判定
- 観点: 欠落/存在の判定
- 合格条件: 想定通り PASS/FAIL

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: CI 統合
- 観点: validator 結果がジョブ結果に反映される
- 合格条件: FAIL 時にCI停止

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 checker 連携
- 観点: validator 導入後も checker が正しく動く
- 合格条件: 既存 pass path 維持

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 正常 profile で実行
  2. キー欠落 profile で実行
  3. `TODO_SET_ME` 含有 profile で実行
- 期待結果: AC-001〜AC-003 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/profile-validate/validate.ps1`
  - `.github/workflows/ci-framework.yml`
  - `project.profile.yaml`
- 影響する仕様:
  - `docs/specs/automation-tools-design-spec.md`
- 非機能影響:
  - 失敗原因の可観測性向上

## 7. 制約とリスク [空欄禁止]

- 制約: 追加依存を最小化する
- 想定リスク: YAML パースの環境差
- 回避策: CIで使用する実行環境を固定する

## 8. 未確定事項 [空欄禁止]

- YAML パース実装の具体方式

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__project-profile-schema-validation/request.md`
- investigation: `work/2026-02-18__project-profile-schema-validation/investigation.md`
- plan: `work/2026-02-18__project-profile-schema-validation/plan.md`
- review: `work/2026-02-18__project-profile-schema-validation/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
