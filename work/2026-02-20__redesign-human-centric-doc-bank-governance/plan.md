# Plan: 2026-02-20__redesign-human-centric-doc-bank-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 本タスクは「再設計計画」を完成させるフェーズであり、実移行は別タスクへ委譲する。

## 1. 対象仕様

- `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`

## 2. plan-draft

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

## 4. plan-final

- 実行フェーズ設計:
  1. Phase A: 方針再設計
     - 目的文と運用原則の再定義
     - 資料バンク情報モデル（目的/使い方/仕組み/実装/関連）の定義
  2. Phase B: 移行計画設計
     - 既存 docs/tools の移行波（inventory -> gap -> rollout）を定義
     - Task B へ依存付きで受け渡し
  3. Phase C: 実行準備
     - backlog/MEMORY/検証コマンドを同期
     - 進行順序を明示（Task A 完了後に Task B 実施）
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
