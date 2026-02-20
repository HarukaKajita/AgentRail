# 仕様書: 2026-02-20__wave0-inventory-human-centric-doc-coverage

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/request.md`
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/investigation.md`
- 理解ポイント:
  - Wave 0: must対象の資料棚卸しと欠落マップ作成 は wave 計画を実行するための分割タスクである。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave0-inventory-human-centric-doc-coverage
- タイトル: Wave 0: must対象の資料棚卸しと欠落マップ作成
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: wave 計画を実行可能な粒度へ分割する必要がある。
- 目的: must対象資料の棚卸しと欠落カテゴリ（目的/使い方/仕組み/実装/関連）の可視化を行う。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- must 対象資料の一覧化と分類軸ベースの棚卸し。
- 欠落カテゴリ（目的/使い方/仕組み/実装/関連）の明文化。
- Wave 1 へ引き継ぐ優先補完対象の提示。
- review と検証結果の記録。

### 3.2 Out of Scope [空欄禁止]

- 依存していない後続 wave タスクの完了。
- 全 docs の一括改修。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: Wave 0 成果物として must対象資料一覧と欠落マップが `docs/operations/wave0-inventory-human-centric-doc-coverage.md` に記録される。
- AC-002: depends_on と backlog/state/plan の整合が維持され、Wave 1 先行タスクの依存状態が更新される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage` の request/investigation/spec/plan/review/state
- 観点: 空欄禁止セクション、依存、成果物定義の整合
- 合格条件: consistency-check -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: depends_on で接続される task 間の整合
- 観点: depends_on 記述と backlog 表示が一致
- 合格条件: 依存 task + 本 task の consistency-check が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の state / consistency 運用
- 観点: 既存完了タスクの PASS を維持
- 合格条件: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 作成した inventory/gap マップと backlog/MEMORY を確認し、次の着手順が明示されることを確認
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage`/*, `docs/operations/wave0-inventory-human-centric-doc-coverage.md`, `docs/operations/high-priority-backlog.md`, `docs/INDEX.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: docs 更新の追跡性とレビュー可能性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - 分類粒度が粗く、Wave 1 の補完指示が曖昧になる
  - docs 導線更新漏れ
- 回避策: 欠落カテゴリを資料単位で明示し、docs-indexer check を完了条件へ含める。

## 8. 未確定事項 [空欄禁止]

- Wave 1 実装時に追加で発見される補完カテゴリは review の Process Findings で管理する。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/request.md`
- investigation: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/investigation.md`
- plan: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/plan.md`
- review: `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/review.md`
- `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
- `docs/operations/human-centric-doc-bank-governance.md`
- `docs/operations/human-centric-doc-bank-migration-plan.md`
- `docs/operations/high-priority-backlog.md`
