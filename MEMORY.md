# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-20__refactor-tools-to-profile-driven-runtime-paths
- タイトル: tools の固定パス参照を profile 起点へ統一
- 状態: in_progress
- 最終更新日時: 2026-02-20T15:30:06+09:00
- 担当: codex

## 2. 今回の目的

- 外部利用向け runtime 配布と導入の基盤を、単一リポジトリ運用のまま整備する。
- 作業成果物を .agentrail/work へ寄せる導入導線を作る。

## 3. 完了済み

- `2026-02-20__define-runtime-manifest-and-export-flow` を完了。
  - `framework.runtime.manifest.yaml` を追加。
  - `runtime/seed/*` を追加。
  - `tools/runtime/export-runtime.ps1` を追加（apply/check/dry-run）。
  - `docs/operations/runtime-distribution-export-guide.md` を追加。
- `2026-02-20__add-runtime-installer-with-agentrail-work-layout` を完了。
  - `tools/runtime/install-runtime.ps1` を追加（dry-run/force/profile更新）。
  - `docs/operations/runtime-installation-runbook.md` を追加。
  - installer で `.agentrail/work/.gitkeep` 生成、`workflow.task_root` / `workflow.runtime_root`、`paths.*` の更新を確認。

## 4. 重要な意思決定

- runtime 配布の SSOT は `framework.runtime.manifest.yaml` とする。
- runtime 配布物の初期ファイルは `runtime/seed/*` で上書きする。
- 導入先の task root は `.agentrail/work` に統一する。
- package 化は別タスク（`2026-02-20__plan-runtime-package-distribution-migration`）で計画先行する。

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `2026-02-20__refactor-tools-to-profile-driven-runtime-paths` に着手する。
2. `tools/*` の `work/docs` 固定参照を `project.profile.yaml` 起点に統一する。
3. その後 `2026-02-20__split-framework-runtime-rules-from-agents` を実施する。

## 7. 参照先

- `docs/operations/high-priority-backlog.md`
- `work/2026-02-20__define-runtime-manifest-and-export-flow/review.md`
- `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か


