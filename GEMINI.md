# AgentRail

## プロジェクト概要

AgentRail は、**要望から実装・テスト・レビュー・資料更新までを一貫して固定化**するための、スタック非依存のエージェント主導開発フレームワークです。
開発プロセスの再現性、追跡可能性、および資料運用の効率化を目的としています。

このリポジトリ自体が AgentRail フレームワークの実装であり、同時にその運用モデルを示すリファレンス実装でもあります。

## 核心概念

1.  **SSOT (Single Source of Truth) の分離**:
    *   **`work/<task-id>/`**: 個別タスクの作業正本。そのタスクにおける変更の根拠と過程を記録します。
    *   **`docs/`**: プロジェクト横断の資料バンク。確定した仕様や運用ルールが集約され、常に最新の状態（Living Documentation）を保ちます。

2.  **9ステップの固定ワークフロー**:
    `AGENTS.md` に定義された以下のフローを厳格に遵守します。
    1.  要望整理 (`request.md`)
    2.  調査 (`investigation.md`)
    3.  要件確定 (`spec.md`)
    4.  実装計画 (`plan.md`)
    5.  実装
    6.  テスト
    7.  レビュー (`review.md`)
    8.  資料更新 (`docs/` および `docs/INDEX.md`)
    9.  記憶更新 (`state.json`, `MEMORY.md`)

## ディレクトリ構成

*   **`AGENTS.md`**: このフレームワークの正本ルール。エージェントはこのファイルに従って行動します。
*   **`project.profile.yaml`**: プロジェクト固有の実行プロファイル（ビルド、テスト、Linter等のコマンド定義）。
*   **`work/`**: タスクごとの作業ディレクトリ。`YYYY-MM-DD__task-name` の形式で管理されます。
*   **`docs/`**: ドキュメント群。
    *   `docs/INDEX.md`: 全資料へのインデックス（`tools/docs-indexer` で管理）。
    *   `docs/specs/`: 仕様書。
    *   `docs/operations/`: 運用手順書。
*   **`tools/`**: 自動化スクリプト群（PowerShell）。整合性チェックやインデックス更新を行います。
*   **`agents/skills/`**: エージェントが使用するスキル定義。

## 運用コマンド (PowerShell)

このプロジェクトは PowerShell (pwsh) で管理されています。

### ドキュメントインデックスの更新
`docs/INDEX.md` の管理セクションを再生成します。資料を追加・変更した際は必ず実行してください。
```powershell
pwsh -NoProfile -File tools/docs-indexer/index.ps1
```

### タスク整合性チェック
タスク内のファイル構成や記述内容（`spec.md` の必須項目など）がルールに適合しているか検証します。
```powershell
pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>
```
例: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`

### プロセス改善の抽出 (Improvement Harvest)
`review.md` に記載された "Process Findings" を検証・抽出します。
```powershell
pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>
```

### フォローアップタスクの起票
抽出された Finding を元に、新しいタスクを起票します。
```powershell
pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId <source-id> -FindingId <finding-id> ...
```

## 開発ワークフロー

1.  **タスク開始**:
    *   `work/YYYY-MM-DD__<task-name>/` ディレクトリを作成。
    *   `docs/templates/` から `spec.md`, `investigation.md`, `review.md` 等をコピー。
    *   `request.md`, `plan.md`, `state.json` を作成。

2.  **実装と検証**:
    *   `spec.md` を記述し、要件を確定。
    *   `plan.md` で実装計画を立案。
    *   実装とテストを実施。
    *   `review.md` で自己レビューと改善点の洗い出し。

3.  **完了**:
    *   関連する `docs/` を更新または新規作成。
    *   `docs/INDEX.md` を更新（ツール実行）。
    *   `state.json` を `done` に更新。
    *   `MEMORY.md` に完了報告と次アクションを追記。

## 規約

*   **言語**: ドキュメント、コミットメッセージ、タスク内ファイルは原則として **日本語** で記述します。
*   **SSOT**: 情報は必ず `docs/` または `work/` に明記し、暗黙知を排除します。
*   **検証**: `tools/consistency-check/check.ps1` が Pass しない状態での完了は認められません。
