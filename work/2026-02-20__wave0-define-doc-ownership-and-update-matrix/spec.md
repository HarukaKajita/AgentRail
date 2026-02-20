# 仕様書: 2026-02-20__wave0-define-doc-ownership-and-update-matrix

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/request.md`
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/investigation.md`
- 理解ポイント:
  - Wave 0: docs更新責務マトリクス定義 は wave 計画の責務境界を確定するための分割タスクである。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave0-define-doc-ownership-and-update-matrix
- タイトル: Wave 0: docs更新責務マトリクス定義
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: Wave 1 以降で docs 更新対象が増えるため、責務境界が曖昧だと更新漏れやレビュー漏れが発生する。
- 目的: task owner / implementation owner / reviewer の責務を資料単位で定義し、更新判断を定型化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- docs 更新責務マトリクス（資料 x ロール）を定義する。
- 変更起点ごとの更新フロー（task/docs/review）を定義する。
- 責務運用の確認チェックリストを作成する。
- review と検証結果の記録。

### 3.2 Out of Scope [空欄禁止]

- Wave 1/2/3 の実装完了。
- validator 実装変更。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 責務マトリクス（task owner / implementation owner / reviewer）が `docs/operations/wave0-doc-ownership-and-update-matrix.md` に定義される。
- AC-002: depends_on と backlog/state/plan の整合が維持され、後続 Wave 1 着手時の責務参照先が明示される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix` の request/investigation/spec/plan/review/state
- 観点: 空欄禁止セクション、依存、責務マトリクス定義の整合
- 合格条件: consistency-check -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: depends_on で接続される task 間の整合
- 観点: depends_on 記述と backlog 表示が一致
- 合格条件: 依存 task + 本 task の consistency-check が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の state / consistency 運用
- 観点: 既存完了タスクの PASS を維持
- 合格条件: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 責務マトリクス docs と backlog/MEMORY を確認し、次の実行タスクで参照可能なことを確認
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix`/*, `docs/operations/wave0-doc-ownership-and-update-matrix.md`, `docs/operations/high-priority-backlog.md`, `docs/INDEX.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: docs 運用の責務明確化によりレビュー再現性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - 責務定義が抽象的で運用者が判断できない
  - docs 導線更新漏れ
- 回避策: 資料別の責務割当と更新トリガーを表形式で明示する。

## 8. 未確定事項 [空欄禁止]

- Wave 1 実施時に発生する例外運用は review の Process Findings で追記する。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/request.md`
- investigation: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/investigation.md`
- plan: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/plan.md`
- review: `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/review.md`
- `docs/operations/wave0-doc-ownership-and-update-matrix.md`
- `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
- `docs/operations/human-centric-doc-bank-governance.md`
- `docs/operations/high-priority-backlog.md`
