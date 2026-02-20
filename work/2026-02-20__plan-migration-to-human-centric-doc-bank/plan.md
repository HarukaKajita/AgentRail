# Plan: 2026-02-20__plan-migration-to-human-centric-doc-bank

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
  - `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`
- 理解ポイント:
  - 本タスクは移行の「設計」タスクであり、実行タスクは本計画から派生起票する。

## 1. 対象仕様

- `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料/仕組みを人間理解中心の資料バンク設計へ移行する段階計画を作る。
- 実施項目:
  1. 移行対象 inventory と優先度分類を定義する。
  2. フェーズ別のゲート、成果物、rollback 条件を定義する。
  3. 実行タスク分割（wave 単位）の起票方針を定義する。
- 成果物:
  - 移行フェーズ定義
  - wave 分割方針
  - 検証/ロールバック手順

## 3. depends_on gate

- 依存: `2026-02-20__redesign-human-centric-doc-bank-governance`
- 判定方針: 依存タスクが `done` になるまで `dependency-blocked` を維持する。
- 判定結果: pass（依存タスク `2026-02-20__redesign-human-centric-doc-bank-governance` が `done`）

## 4. 確定実装計画 (Plan Final)

- フェーズ構成:
  1. Wave 0: Inventory
     - docs と tools の現状マッピングを作成
     - 欠落情報カテゴリを抽出
  2. Wave 1: Core Docs Migration
     - 目的/使い方/仕組み/実装マッピングを主要資料へ反映
     - 導線と責務記述を統一
  3. Wave 2: Validation Migration
     - consistency/state-validate へ追加すべきチェック方針を定義
     - CI 運用への段階導入手順を定義
  4. Wave 3: Stabilization
     - 運用メトリクスを観測し改善タスクへ接続
- 成果物:
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - Wave 0-3 の入力/出力/ゲート/rollback 定義
  - 派生タスク分割方針
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
  3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 依存整合が崩れた場合は Task B を `blocked` に戻し、Wave 定義を再設計する

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__plan-migration-to-human-centric-doc-bank/review.md` に記録する。
- Task A 依存を前提に、実行タスク分割が可能な粒度で計画が定義されている。
