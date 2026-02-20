# Runtime Installation Runbook

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/runtime-distribution-export-guide.md`
- 理解ポイント:
  - install 前に runtime 配布物（`dist/runtime`）が生成済みであることを確認する。


## 1. 目的

- runtime 配布物を外部リポジトリへ導入する。
- 導入先 task 成果物を `.agentrail/work` に統一する。

## 2. 前提条件

1. `tools/runtime/export-runtime.ps1 -Mode apply` が完了している。
2. 導入先ディレクトリが存在する（なければ installer が作成する）。

## 3. 実行コマンド

### 3.1 Dry-Run（推奨）

```powershell
pwsh -NoProfile -File tools/runtime/install-runtime.ps1 `
  -TargetRoot <target-root> `
  -DryRun
```

### 3.2 Apply

```powershell
pwsh -NoProfile -File tools/runtime/install-runtime.ps1 `
  -TargetRoot <target-root>
```

### 3.3 競合ファイルを上書きする場合

```powershell
pwsh -NoProfile -File tools/runtime/install-runtime.ps1 `
  -TargetRoot <target-root> `
  -Force
```

## 4. 導入後の期待状態

- `<target-root>/.agentrail/work/` が存在する。
- `<target-root>/.agentrail/work/.gitkeep` が生成される。
- `<target-root>/project.profile.yaml` に以下が反映される:
  - `workflow.task_root: ".agentrail/work"`
  - `workflow.runtime_root: ".agentrail"`

## 5. トラブルシュート

1. `Conflicting files detected` が出る場合:
   - Dry-Run の出力を確認し、上書き可能なら `-Force` を付与する。
2. `project.profile.yaml not found` が出る場合:
   - 先に `tools/runtime/export-runtime.ps1 -Mode apply` で runtime 配布物を再生成してから再実行する。

## 6. 関連資料リンク

- docs:
  - `docs/operations/runtime-distribution-export-guide.md`
  - `docs/operations/high-priority-backlog.md`
- work:
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md`
