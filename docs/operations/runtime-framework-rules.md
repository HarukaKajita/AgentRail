# Runtime Framework Rules

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `project.profile.yaml`
  - `framework.runtime.manifest.yaml`
  - `docs/operations/runtime-distribution-export-guide.md`
  - `docs/operations/runtime-installation-runbook.md`
- 理解ポイント:
  - runtime 配布境界と導入境界を分離して管理し、外部導入時の再現性を担保する。

## 1. 目的

- runtime 配布に必須なルールを一箇所に集約し、`AGENTS.md` から詳細規約を分離する。
- 開発用資産と導入先で必要な資産の境界を明確にする。

## 2. 適用範囲

- `tools/runtime/export-runtime.ps1` による runtime 配布物生成
- `tools/runtime/install-runtime.ps1` による外部導入
- profile 起点で動作する framework ツール群

## 3. 必須ルール

1. 配布境界の SSOT は `framework.runtime.manifest.yaml` とする。
2. runtime seed は `runtime/seed/*` のみを初期値として扱う。
3. 導入先の task root は `workflow.task_root` で管理し、標準値は `.agentrail/work` とする。
4. runtime 関連ツールは `project.profile.yaml` の `workflow.task_root` / `workflow.docs_root` / `workflow.runtime_root` を起点にパス解決する。
5. runtime ルール変更時は本資料、`AGENTS.md` の要旨、`docs/INDEX.md` を同一変更で更新する。

## 4. 検証コマンド

- `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode check`
- `pwsh -NoProfile -File tools/runtime/install-runtime.ps1 -TargetRoot <target-root> -DryRun`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id>`

## 5. 非対象

- package 配布方式の最終決定（別タスクで計画）
- Core/Dogfood リポジトリ分割

## 6. 関連資料

- `docs/operations/runtime-distribution-export-guide.md`
- `docs/operations/runtime-installation-runbook.md`
- `work/2026-02-20__split-framework-runtime-rules-from-agents/spec.md`
