# Plan: 2026-02-20__redesign-human-centric-doc-bank-governance

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 本タスクは「再設計計画」を完成させるフェーズであり、実移行は別タスクへ委譲する。

## 1. 対象仕様

- `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: 人間理解中心の資料バンク方針へ再設計するための計画を確定する。
- 実施項目:
  1. 現行運用との差分（目的定義、情報モデル、更新責務）を明確化する。
  2. 高精度進行のための段階計画とゲート条件を定義する。
  3. 移行計画専用タスクを依存付きで起票する。
- 成果物:
  - 再設計計画 task 一式
  - 移行計画 task 一式（Task B）
  - backlog と MEMORY の同期更新

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため plan-ready を採用する。
- 判定結果: pass（依存なし）

## 4. 確定実装計画 (Plan Final)

- 実行フェーズ設計:
  1. Phase A: 方針再設計
     - 目的文を「再現性 + 人間理解」へ拡張する。
     - 運用原則（網羅性/鮮度/追跡性/可読性）を明文化する。
  2. Phase B: ガバナンス文書化
     - `docs/operations/human-centric-doc-bank-governance.md` を作成し、情報モデルと品質ゲートを定義する。
     - 更新責務（task owner / implementation owner / reviewer）を定義する。
  3. Phase C: 依存連携と実行準備
     - Task B への依存順序（Task A -> Task B）を維持し、backlog へ反映する。
     - backlog / MEMORY / state / docs index を同期する。
- タスク分割:
  1. `2026-02-20__redesign-human-centric-doc-bank-governance`（本タスク）
  2. `2026-02-20__plan-migration-to-human-centric-doc-bank`（Task B, depends_on: Task A）
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__redesign-human-centric-doc-bank-governance`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 起票差分を task 単位で巻き戻し、依存関係と gate 記述を再生成する

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__redesign-human-centric-doc-bank-governance`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- 受入条件 AC-001/AC-002 の判定結果を `work/2026-02-20__redesign-human-centric-doc-bank-governance/review.md` に記録する。
- Task B の起票と依存整合が確認できる。
