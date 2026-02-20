# AgentRail Runtime Bundle

このファイル群は、外部リポジトリへ AgentRail フレームワークを導入するための runtime 配布物です。  
本リポジトリの開発用履歴（`work/*`、`archive/*` など）は含めません。

## 1. 目的

- フレームワークの実行に必要な最小ファイルのみを提供する。
- 導入先リポジトリで framework 開発資料と混在させない。

## 2. 主要エントリ

- `AGENTS.md`
- `project.profile.yaml`
- `tools/*`
- `docs/templates/*`
- `docs/operations/high-priority-backlog.md`

## 3. 更新方針

- runtime 配布内容は `framework.runtime.manifest.yaml` を SSOT とする。
- 配布物更新時は `tools/runtime/export-runtime.ps1` を使って再生成する。
