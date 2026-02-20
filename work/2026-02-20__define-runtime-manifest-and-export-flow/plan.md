# Plan: 2026-02-20__define-runtime-manifest-and-export-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/spec.md`
- 理解ポイント:
  - 実装前に depends_on とゲート状態を確認する。

## 1. 対象仕様

- `work/2026-02-20__define-runtime-manifest-and-export-flow/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: 配布対象を allowlist 化し、外部利用時に不要な開発用ファイル混入を防止する。
- 実施項目:
  1. runtime 配布対象・除外対象・seed ファイルを `framework.runtime.manifest.yaml` に定義する。
  2. `tools/runtime/export-runtime.ps1` に apply/check/dry-run を実装する。
  3. runtime 配布運用資料を `docs/operations` に追加する。
- 成果物:
  - `framework.runtime.manifest.yaml`
  - `runtime/seed/*`
  - `tools/runtime/export-runtime.ps1`
  - `docs/operations/runtime-distribution-export-guide.md`

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため plan-ready 判定を採用する。

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. `framework.runtime.manifest.yaml` と `runtime/seed/*` を作成し、runtime 出力の骨格を固定する。
  2. `tools/runtime/export-runtime.ps1` を実装し、manifest から file plan を生成して apply/check 可能にする。
  3. 運用資料・task 記録・`project.profile.yaml` を更新し、検証結果を `review.md` に反映する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply`
  2. `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode check`
  3. `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply -DryRun`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__define-runtime-manifest-and-export-flow`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__define-runtime-manifest-and-export-flow`
- ロールバック: 対象コミットを単位に戻し、spec と plan を再確認して再実装する

## 5. Execution Commands

- `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply`
- `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode check`
- `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply -DryRun`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__define-runtime-manifest-and-export-flow`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__define-runtime-manifest-and-export-flow`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- 受入条件の判定結果を `work/2026-02-20__define-runtime-manifest-and-export-flow/review.md` に記録する。
- 対象 task の検証コマンドが成功する。
