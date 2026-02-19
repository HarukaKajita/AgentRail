# 仕様書: 2026-02-20__fix-improvement-create-task-dependency-placeholder

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/request.md`
  - `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/investigation.md`
- 理解ポイント:
  - 問題を再現し、修正内容と検証条件を 1:1 で対応させる。

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-20__fix-improvement-create-task-dependency-placeholder`
- タイトル: Fix dependency placeholder in create-task output
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: Repository review で "create-task 生成結果の investigation.md に $depends_on プレースホルダが残留する。" が検出された。
- 目的: 対象不備を解消し、再検証可能な運用状態へ戻す。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 問題箇所の修正。
- 必要な docs/運用記述の整合。
- 再発防止のための検証手順更新。

### 3.2 Out of Scope [空欄禁止]

- 本不備と無関係な機能追加。
- リポジトリ全体の大規模設計変更。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: "create-task 生成結果の investigation.md に $depends_on プレースホルダが残留する。" を再現できなくなる。
- AC-002: 影響範囲の docs / スクリプト整合が保たれる。
- AC-003: 対象タスクの consistency/state 検証が PASS する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 問題の根本箇所を含むファイル。
- 観点: 修正ロジックが期待どおりに動作する。
- 合格条件: 失敗条件が再現せず期待結果になる。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 影響する workflow / scripts / docs 導線。
- 観点: 連携実行時の動作整合。
- 合格条件: 連携コマンドが成功し、矛盾がない。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存の関連チェック。
- 観点: 修正により既存運用を壊さない。
- 合格条件: 既存チェックが PASS を維持する。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 実装後に対象再現手順と各チェックコマンドを実行する。
- 期待結果: AC-001 から AC-003 を満たす。

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/improvement-harvest/create-task.ps1`
- 影響する仕様:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 非機能影響:
  - 運用の再現性とメンテナンス性が向上する。

## 7. 制約とリスク [空欄禁止]

- 制約: 既存ルール（AGENTS.md）と整合すること。
- 想定リスク: 修正漏れにより類似不備が残る可能性。
- 回避策: 影響範囲のチェックを明示し review で検証する。

## 8. 未確定事項 [空欄禁止]

- 実装時に判明する副作用の有無。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/request.md`
- investigation: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/investigation.md`
- plan: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/plan.md`
- review: `work/2026-02-20__fix-improvement-create-task-dependency-placeholder/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
