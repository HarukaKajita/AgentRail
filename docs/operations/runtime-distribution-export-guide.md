# Runtime Distribution Export Guide

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `framework.runtime.manifest.yaml`
- 理解ポイント:
  - runtime 配布物は manifest を SSOT として再生成する。


## 1. 目的

- 外部リポジトリで使う runtime 配布物を、開発用資産と分離して生成する。
- 手動削除を前提にせず、allowlist ベースで再現可能に出力する。

## 2. 入力と出力

- 入力:
  - `framework.runtime.manifest.yaml`
  - `runtime/seed/*`
- 出力:
  - `dist/runtime`

## 3. manifest の主要キー

- `schema_version`
  - manifest のスキーマ版
- `output_root`
  - 出力先ルート
- `include_paths`
  - 配布対象として取り込むファイル/ディレクトリ
- `seed_files`
  - `<source> => <destination>` 形式で、配布物へ上書き配置するテンプレート
- `exclude_paths`
  - 出力対象から除外するパス（prefix 判定）
- `exclude_globs`
  - 出力対象から除外する glob

## 4. 実行コマンド

### 4.1 配布物を生成する

```powershell
pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply
```

### 4.2 配布物が manifest と同期しているか確認する

```powershell
pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode check
```

### 4.3 変更計画だけ確認する

```powershell
pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply -DryRun
```

## 5. 運用ルール

1. runtime 構成を変更する場合は、先に `framework.runtime.manifest.yaml` を更新する。
2. `runtime/seed/*` は導入先で初期値として必要なファイルのみ置く。
3. `dist/runtime` は生成物として扱い、配布前に `-Mode check` を必ず実行する。

## 6. 次工程

- runtime 導入は `docs/operations/runtime-installation-runbook.md` を参照する。

## 7. 関連資料リンク

- docs:
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/high-priority-backlog.md`
- work:
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/spec.md`
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/review.md`
