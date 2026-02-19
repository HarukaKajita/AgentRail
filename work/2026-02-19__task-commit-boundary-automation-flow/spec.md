# 仕様書: 2026-02-19__task-commit-boundary-automation-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__task-commit-boundary-automation-flow`
- タイトル: Commit Boundary Automation Flow
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__task-commit-boundary-automation-flow/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: 現行運用ではコミットが最終工程に偏りやすく、複数作業の差分が stage で混在するリスクがある。
- 目的: 起票後・実行後などの節目でコミットを行う標準フローを定義し、差分混在を自動検知して作業単位で履歴を分離する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- コミット境界の標準ルールを定義する。
  - 起票完了後コミット
  - 実装完了後コミット
  - review/docs/memory 完了後コミット
- stage 混在検知ルールを定義する。
  - 単一コミットに含める差分が単一taskに閉じること
  - 例外許容（共通基盤変更など）の条件と記録方法
- フロー反映範囲を定義する。
  - `AGENTS.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - 該当スキル運用
- 検証導入範囲を定義する。
  - commit前チェックまたは checker で混在検知
  - 失敗時の是正手順
- backlog/state/review でコミット境界運用の実施状態を追跡する要件を定義する。

### 3.2 Out of Scope [空欄禁止]

- Gitフックの全環境強制インストール。
- 既存過去コミットの再分割。
- 外部CIサービス連携の全面刷新。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: コミット境界（起票後・実装後・完了後）の標準タイミングと命名規則が定義される。
- AC-002: 単一task差分制約と例外条件が定義される。
- AC-003: 混在検知の実施方法（コマンド、判定条件、エラーメッセージ）が定義される。
- AC-004: docs/skills/workflow の更新範囲と反映順序が定義される。
- AC-005: backlog と task 文書でコミット境界運用を追跡できる要件が定義される。
- AC-006: 移行方針（既存taskへの適用条件、fail-open/fail-close の段階適用）が定義される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 混在検知ロジック（差分ファイル分類、単一task判定、例外判定）
- 観点:
  - 単一task差分は PASS
  - 複数task差分は FAIL
  - 許容例外を伴うケースは条件一致時のみ PASS
- 合格条件: 正常系1ケース、異常系2ケース、例外系1ケース以上で期待判定を返す。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 起票→実装→完了の各フェーズにおけるコミット境界運用
- 観点:
  - 起票後に task 起票差分のみでコミットできる。
  - 実装後に実装差分のみでコミットできる。
  - 完了後に review/docs/memory 差分のみでコミットできる。
- 合格条件: 3フェーズで混在検知に抵触せずコミットできる。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 task 運用・checker・state validate
- 観点:
  - 既存フロー（consistency/state/docs）が維持される。
  - コミット境界追加後も planned/done 運用を阻害しない。
- 合格条件:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks` PASS
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 起票直後に起票差分のみを stage して境界コミットを実行する。
  2. 実装差分に別task差分を意図的に混在させ、混在検知が FAIL することを確認する。
  3. 差分を分離して再実行し、コミット成功することを確認する。
  4. 完了フェーズで review/docs/memory 更新差分のみをコミットできることを確認する。
- 期待結果: 差分混在は fail-fast され、作業境界ごとのコミット分離が維持される。

### 5.5 AC-テスト対応表 [空欄禁止]

- AC-001: Integration Test + Manual Verification-1/4
- AC-002: Unit Test + Manual Verification-2/3
- AC-003: Unit Test + Manual Verification-2
- AC-004: Regression Test
- AC-005: Integration Test + Manual Verification-4
- AC-006: Regression Test + Manual Verification-3/4

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `AGENTS.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `.agents/skills/*/SKILL.md`（必要対象）
  - `docs/operations/high-priority-backlog.md`
- 影響する仕様:
  - タスク実行フロー
  - コミット運用
  - レビュー運用
- 非機能影響:
  - 差分追跡性向上
  - レビュー効率向上
  - ロールバック容易性向上

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 既存の非破壊運用ルール（未関連変更を勝手に戻さない）を維持する。
  - 自動化導入後も手動上書き不能な過剰制約にしない。
- 想定リスク:
  - 厳格化しすぎると共通基盤変更時の作業効率が低下する。
  - 境界定義が曖昧だと誤判定が増える。
- 回避策:
  - 例外ケースの明文化と根拠記録欄を設ける。
  - fail-open から fail-close へ段階移行する。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__task-commit-boundary-automation-flow/request.md`
- investigation: `work/2026-02-19__task-commit-boundary-automation-flow/investigation.md`
- plan: `work/2026-02-19__task-commit-boundary-automation-flow/plan.md`
- review: `work/2026-02-19__task-commit-boundary-automation-flow/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
