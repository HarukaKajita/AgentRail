# 仕様書: 2026-02-20__allow-schema-governance-without-base-sha

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__allow-schema-governance-without-base-sha/request.md`
  - `work/2026-02-20__allow-schema-governance-without-base-sha/investigation.md`
- 理解ポイント:
  - 問題を再現し、修正内容と検証条件を 1:1 で対応させる。

## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-20__allow-schema-governance-without-base-sha`
- タイトル: Handle schema governance without base sha
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__allow-schema-governance-without-base-sha/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: Repository review で "schema governance が BaseSha なし（初回 push 等）で不必要に FAIL する。" が検出された。
- 目的: 対象不備を解消し、再検証可能な運用状態へ戻す。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- 問題箇所の修正。
- 必要な docs/運用記述の整合。
- 再発防止のための検証手順更新。

### 3.2 Out of Scope (必須)

- 本不備と無関係な機能追加。
- リポジトリ全体の大規模設計変更。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: "schema governance が BaseSha なし（初回 push 等）で不必要に FAIL する。" を再現できなくなる。
- AC-002: 影響範囲の docs / スクリプト整合が保たれる。
- AC-003: 対象タスクの consistency/state 検証が PASS する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 問題の根本箇所を含むファイル。
- **検証項目**: 修正ロジックが期待どおりに動作する。
- **合格基準**: 失敗条件が再現せず期待結果になる。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: 影響する workflow / scripts / docs 導線。
- **検証項目**: 連携実行時の動作整合。
- **合格基準**: 連携コマンドが成功し、矛盾がない。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の関連チェック。
- **検証項目**: 修正により既存運用を壊さない。
- **合格基準**: 既存チェックが PASS を維持する。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: 実装後に対象再現手順と各チェックコマンドを実行する。
- **期待される結果**: AC-001 から AC-003 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/profile-validate/check-schema-governance.ps1`
  - `.github/workflows/ci-framework.yml`
- 影響する仕様:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 非機能影響:
  - 運用の再現性とメンテナンス性が向上する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 既存ルール（AGENTS.md）と整合すること。
- 想定リスク: 修正漏れにより類似不備が残る可能性。
- 回避策: 影響範囲のチェックを明示し review で検証する。

## 8. 未確定事項 (Open Issues) (必須)

- 実装時に判明する副作用の有無。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__allow-schema-governance-without-base-sha/request.md`
- investigation: `work/2026-02-20__allow-schema-governance-without-base-sha/investigation.md`
- plan: `work/2026-02-20__allow-schema-governance-without-base-sha/plan.md`
- review: `work/2026-02-20__allow-schema-governance-without-base-sha/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
