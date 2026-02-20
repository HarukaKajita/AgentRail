# Human-Centric Doc Bank Migration Plan

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`
- 理解ポイント:
  - 本資料は「既存資産を段階移行するための計画」であり、実装作業は派生タスクで実施する。

## 1. 目的

- 既存 docs/tools を人間理解中心の情報モデルへ段階移行する。
- 依存順序、ゲート、ロールバックを先に定義し、移行中の品質劣化を防ぐ。

## 2. 対象と優先度

### 2.1 Must (Wave 0-1)

- `docs/INDEX.md`
- `docs/operations/*` の主要運用資料
- `README.md`
- `AGENTS.md`

### 2.2 Should (Wave 2)

- `tools/consistency-check/check.ps1` の docs 内容検証方針
- `tools/state-validate/validate.ps1` の完了判定補強方針
- CI 運用資料（runbook）との整合手順

### 2.3 Later (Wave 3+)

- 定量 KPI の自動集計
- docs 品質メトリクスの可視化

## 3. Wave 計画

### Wave 0: Inventory

- 入力:
  - `docs/INDEX.md`
  - `docs/operations/*.md`
  - `work/*/spec.md`
- 出力:
  - 対象一覧（機能/資料/責務/不足カテゴリ）
  - 欠落マップ（目的/使い方/仕組み/実装/関連）
- ゲート:
  - 対象一覧に must 領域が 100% 含まれる
  - 欠落カテゴリが明文化される
- rollback:
  - 分類基準が曖昧な場合はカテゴリ定義を見直して再棚卸し

### Wave 1: Core Docs Migration

- 入力:
  - Wave 0 の対象一覧と欠落マップ
  - `docs/operations/human-centric-doc-bank-governance.md`
- 出力:
  - 主要 docs の記述補完（目的/使い方/仕組み/実装/関連）
  - docs 導線更新（`docs/INDEX.md`）
- ゲート:
  - must 領域 docs が新情報モデルに適合
  - 主要 docs の参照切れがない
- rollback:
  - 影響範囲を wave 単位で戻し、導線更新を先に復旧

### Wave 2: Validation Migration

- 入力:
  - Wave 1 適用結果
  - 現行 `consistency-check` / `state-validate` 実装
- 出力:
  - 追加検証項目の設計メモ
  - 導入順序（warning -> fail の段階導入）
- ゲート:
  - 既存 PASS タスクを壊さない導入計画になっている
  - CI への反映手順が明記される
- rollback:
  - fail 条件を warning へ戻し、段階導入に戻す

### Wave 3: Stabilization

- 入力:
  - Wave 2 までの適用結果
- 出力:
  - 運用メトリクス定義（更新遅延/導線整合/網羅率）
  - KPI 閾値定義 docs（`docs/operations/wave3-doc-quality-kpi-thresholds.md`）
  - KPI 自動集計 docs（`docs/operations/wave3-doc-quality-metrics-report-automation.md`）
  - KPI 改善ループ docs（`docs/operations/wave3-kpi-process-findings-loop.md`）
  - 継続改善タスクの優先度基準
- ゲート:
  - KPI 閾値の暫定版が合意される
  - 改善ループへ接続できる
- rollback:
  - KPI の閾値が過剰な場合、暫定閾値へ引き戻す

## 4. 派生タスク分割方針

1. Wave 0 実行タスク
   - 対象棚卸しとギャップ分類を担当
2. Wave 1 実行タスク
   - docs 記述移行と導線整合を担当
3. Wave 2 実行タスク
   - 検証ルール拡張設計を担当
4. Wave 3 実行タスク
   - KPI 安定化と継続改善連携を担当

## 5. 検証コマンド

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 進行順序

- 前提: Task A (`2026-02-20__redesign-human-centric-doc-bank-governance`) が `done`
- 着手順:
  1. Wave 0 タスク
  2. Wave 1 タスク
  3. Wave 2 タスク
  4. Wave 3 タスク
