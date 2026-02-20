# 仕様書: 2026-02-18__state-transition-validation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__state-transition-validation`
- タイトル: state.json 状態遷移検証
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__state-transition-validation/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: state 値の妥当性と完了整合を機械検証していない。
- 目的: state validator を導入し、状態不整合を CI で検知する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/state-validate/validate.ps1` 追加
- state 値の許可セット検証
- `done` 時の整合条件検証
- CI 組み込み

### 3.2 Out of Scope (必須)

- state 履歴ファイルの導入
- task テンプレート全面刷新

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `state` が許可値外の場合 FAIL
- AC-002: 必須キー欠落時に FAIL
- AC-003: `done` で整合条件未達なら FAIL
- AC-004: 正常 task で PASS
- AC-005: CI で validator が実行される

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: state 値判定
- **検証項目**: 許可値/不許可値の分岐
- **合格基準**: 想定どおり PASS/FAIL

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: CI 連携
- **検証項目**: validator 結果のジョブ反映
- **合格基準**: FAIL 時にCI停止

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 task
- **検証項目**: 正常 task が誤検知されない
- **合格基準**: 現在の done task で PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. 正常 state で実行
  2. 不正 state 値で実行
  3. 必須キー欠落 state で実行
- **期待される結果**: AC-001〜AC-004 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/state-validate/validate.ps1`
  - `.github/workflows/ci-framework.yml`
  - `work/*/state.json`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 非機能影響:
  - 状態管理の信頼性向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 現在は遷移履歴を保持していない
- 想定リスク: 過剰な厳格化で運用が止まる
- 回避策: 初期は最小整合条件から導入し段階的に強化

## 8. 未確定事項 (Open Issues) (必須)

- 遷移履歴なしでの「遷移違反」定義の最終仕様

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__state-transition-validation/request.md`
- investigation: `work/2026-02-18__state-transition-validation/investigation.md`
- plan: `work/2026-02-18__state-transition-validation/plan.md`
- review: `work/2026-02-18__state-transition-validation/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
