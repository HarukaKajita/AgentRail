# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-20__plan-migration-to-human-centric-doc-bank
- タイトル: 人間理解中心資料バンクへの既存資産移行計画を起票
- 状態: done
- 最終更新日時: 2026-02-20T16:52:26+09:00
- 担当: codex

## 2. 今回の目的

- フレームワーク目的を「再現性 + 人間理解」へ拡張したうえで、既存資産の段階移行計画を確定する。
- Wave 0-3 の実行順序と検証/ロールバック方針を次段タスクへ受け渡せる状態にする。

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
- `2026-02-20__refactor-tools-to-profile-driven-runtime-paths` を完了。
  - `tools/common/profile-paths.ps1` を追加し、workflow root の共通解決を導入。
  - `consistency/state/resolve/improvement/commit-boundary` 系ツールの `work/docs` 固定参照を profile 起点へ置換。
  - `.agentrail/work` / `.agentrail/docs` プロファイルのスモーク検証で create/check/validate を確認。
- `2026-02-20__split-framework-runtime-rules-from-agents` を完了。
  - `docs/operations/runtime-framework-rules.md` を追加し、runtime 必須ルールを正本化。
  - `AGENTS.md` は runtime 要旨と参照リンク中心へ整理。
  - `README.md` と `docs/INDEX.md` に runtime ルール導線を追加。
- `2026-02-20__plan-runtime-package-distribution-migration` を完了。
  - `docs/operations/runtime-package-distribution-migration-plan.md` を追加し、移行条件・互換ポリシー・実施フェーズ・ロールバックを定義。
  - task 側の `request/spec/plan/review/state` を完了状態へ更新。
- `2026-02-20__redesign-human-centric-doc-bank-governance` を完了。
  - `docs/operations/human-centric-doc-bank-governance.md` を追加し、運用原則・情報モデル・品質ゲートを定義。
  - `AGENTS.md` と `README.md` の目的記述を「再現性 + 人間理解」へ更新。
  - backlog と task state の依存整合を更新し、Task B を plan-ready に切り替え。
- `2026-02-20__plan-migration-to-human-centric-doc-bank` を完了。
  - `docs/operations/human-centric-doc-bank-migration-plan.md` を追加し、Wave 0-3 の移行計画を定義。
  - Task A 依存ゲートを pass 化し、Task B の `review/state/backlog` を完了状態へ更新。

## 4. 重要な意思決定

- runtime 配布の SSOT は `framework.runtime.manifest.yaml` とする。
- runtime 配布物の初期ファイルは `runtime/seed/*` で上書きする。
- 導入先の task root は `.agentrail/work` に統一する。
- package 化は別タスク（`2026-02-20__plan-runtime-package-distribution-migration`）で計画先行する。
- 人間理解中心 docs ガバナンスの正本は `docs/operations/human-centric-doc-bank-governance.md` とする。
- 既存資産移行の正本計画は `docs/operations/human-centric-doc-bank-migration-plan.md` とする。

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. Wave 0（Inventory）実行タスクを起票し、対象棚卸しを開始する。
2. Wave 1（Core Docs Migration）準備として must 領域 docs の不足カテゴリを確定する。
3. docs 品質ゲートのしきい値（更新遅延・網羅率）を Wave 3 で確定する。

## 7. 参照先

- `docs/operations/high-priority-backlog.md`
- `docs/operations/human-centric-doc-bank-governance.md`
- `docs/operations/human-centric-doc-bank-migration-plan.md`
- `work/2026-02-20__define-runtime-manifest-and-export-flow/review.md`
- `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md`
- `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/review.md`
- `work/2026-02-20__split-framework-runtime-rules-from-agents/review.md`
- `work/2026-02-20__plan-runtime-package-distribution-migration/review.md`
- `work/2026-02-20__redesign-human-centric-doc-bank-governance/review.md`
- `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- `work/2026-02-20__plan-migration-to-human-centric-doc-bank/review.md`
- `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か


