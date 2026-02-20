# Plan: 2026-02-20__wave1-migrate-core-docs-to-human-centric-model

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/spec.md`
- 理解ポイント:
  - core docs の導線補完は Wave 1 全体の先行タスクであり、operations docs 補完の前提となる。

## 1. 対象仕様

- `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/spec.md`

## 2. plan-draft

- 目的: `AGENTS.md`、`README.md`、`docs/INDEX.md` を人間理解中心の情報モデルへ適合させる。
- 実施項目:
  1. core docs の不足カテゴリに対応する導線見出しと参照先を定義する。
  2. `AGENTS.md` / `README.md` / `docs/INDEX.md` を最小差分で補完する。
  3. 変更内容を Wave 1 core 移行記録として docs 化する。
- 成果物:
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `AGENTS.md` / `README.md` / `docs/INDEX.md` の導線補完
  - task 成果物 6 ファイルと backlog/MEMORY 更新

## 3. depends_on gate

- 依存: 2026-02-20__wave0-inventory-human-centric-doc-coverage
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: Wave 0 inventory の不足カテゴリを core docs 対応項目へ割り当てる。
  2. 実施: `AGENTS.md` / `README.md` / `docs/INDEX.md` へ導線セクションを追加する。
  3. 記録: `docs/operations/wave1-core-docs-human-centric-migration.md` に移行結果を記録する。
  4. 整合: `spec.md`、`review.md`、`state.json`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` を更新する。
  5. 検証: consistency/state/docs-indexer を実行する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: core docs の可読性を損なう変更が出た場合は導線セクションを最小構成へ戻し、wave1-core 記録 docs 側に説明を退避する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/review.md` に記録する。
- core docs 3ファイルに導線補完が反映され、Wave 1 operations task が参照可能な状態になっている。
