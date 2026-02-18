# 仕様書: 2026-02-18__state-transition-validation

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__state-transition-validation`
- タイトル: state.json 状態遷移検証
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__state-transition-validation/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: state 値の妥当性と完了整合を機械検証していない。
- 目的: state validator を導入し、状態不整合を CI で検知する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/state-validate/validate.ps1` 追加
- state 値の許可セット検証
- `done` 時の整合条件検証
- CI 組み込み

### 3.2 Out of Scope [空欄禁止]

- state 履歴ファイルの導入
- task テンプレート全面刷新

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `state` が許可値外の場合 FAIL
- AC-002: 必須キー欠落時に FAIL
- AC-003: `done` で整合条件未達なら FAIL
- AC-004: 正常 task で PASS
- AC-005: CI で validator が実行される

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: state 値判定
- 観点: 許可値/不許可値の分岐
- 合格条件: 想定どおり PASS/FAIL

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: CI 連携
- 観点: validator 結果のジョブ反映
- 合格条件: FAIL 時にCI停止

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 task
- 観点: 正常 task が誤検知されない
- 合格条件: 現在の done task で PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 正常 state で実行
  2. 不正 state 値で実行
  3. 必須キー欠落 state で実行
- 期待結果: AC-001〜AC-004 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/state-validate/validate.ps1`
  - `.github/workflows/ci-framework.yml`
  - `work/*/state.json`
- 影響する仕様:
  - `docs/specs/phase2-ci-integration-spec.md`
- 非機能影響:
  - 状態管理の信頼性向上

## 7. 制約とリスク [空欄禁止]

- 制約: 現在は遷移履歴を保持していない
- 想定リスク: 過剰な厳格化で運用が止まる
- 回避策: 初期は最小整合条件から導入し段階的に強化

## 8. 未確定事項 [空欄禁止]

- 遷移履歴なしでの「遷移違反」定義の最終仕様

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__state-transition-validation/request.md`
- investigation: `work/2026-02-18__state-transition-validation/investigation.md`
- plan: `work/2026-02-18__state-transition-validation/plan.md`
- review: `work/2026-02-18__state-transition-validation/review.md`
- docs:
  - `docs/specs/phase2-automation-spec.md`
  - `docs/specs/phase2-ci-integration-spec.md`
