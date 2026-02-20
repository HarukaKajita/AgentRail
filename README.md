# AgentRail

AgentRail は、**要望から実装、テスト、レビュー、ドキュメント更新に至る全工程を標準化**するための、技術スタックに依存しない開発フレームワークです。  
コードの実装そのもの以上に、**開発プロセスの再現性・追跡可能性・可読性**と、**人間が最短で理解できる資料運用**を重視して設計されています。

---

## 1. 解決する課題

AgentRail は、現代の開発現場で頻発する以下の問題を解決します。

- 要件、設計、実装の関係性が断絶し、仕様が散逸する
- 「なぜこのように実装したのか」という背景が不透明になる
- 作業の中断や担当者の交代により、コンテキストが失われる
- ドキュメントの更新漏れや、実コードとの不整合が発生する

本フレームワークでは、以下の 2 つを SSOT (信頼できる唯一の情報源) として運用します。

- **`work/<task-id>/`**: 個別タスクの作業記録（プロセス正本）
- **`docs/`**: プロジェクト横断の資料バンク（目的・構造・実装・関連情報の導線を維持）

### 1.1 人間中心のクイック導線 (Human-Centric Quick Path)

最短でプロジェクトの全体像を把握するには、以下の順序で資料を確認してください。

1. **目的**: `AGENTS.md` の「1. 目的」および「7. 完了条件」
2. **使用方法**: `README.md` の「5. 使用方法」
3. **構造**: `README.md` の「2. 構成要素」および「3. 動作フロー」
4. **実装**: `tools/` 配下のスクリプトおよび `project.profile.yaml`
5. **関連情報**: `docs/INDEX.md` および `docs/operations/high-priority-backlog.md`

---

## 2. 構成要素

### 2.1 ルール層
- **`AGENTS.md`**: フレームワークの正本ルール。ワークフロー、ブロック条件、完了条件を定義。
- **`CLAUDE.md`**: 特定エージェント向けの補助ルール（矛盾時は `AGENTS.md` を優先）。

### 2.2 タスク層 (`work/`)
各タスクは `work/<task-id>/` ディレクトリ内で完結し、以下の 6 ファイルを保持します。
- `request.md`: 要望整理
- `investigation.md`: 調査・分析記録
- `spec.md`: 要件仕様（受入条件・テスト要件を含む）
- `plan.md`: 実装計画
- `review.md`: レビュー結果・検証記録
- `state.json`: 状態管理データ (`planned` / `in_progress` / `done` 等)

### 2.3 ドキュメント層 (`docs/`)
- `docs/specs/`: 確定した各種仕様書
- `docs/decisions/`: ADR (意思決定記録)
- `docs/investigations/`: 調査記録
- `docs/operations/`: 運用手順書・ランブック
- `docs/templates/`: 各種ファイルのテンプレート
- `docs/INDEX.md`: 全資料へのインデックス

### 2.4 自動化層 (`tools/`)
- `tools/docs-indexer/`: `docs/INDEX.md` の管理セクションを自動更新。
- `tools/consistency-check/`: タスクファイルの整合性（必須項目、リンク、状態等）を検証。
- `tools/ci/`: CI 環境でのタスク解決および検証を支援。
- `tools/improvement-harvest/`: `review.md` から改善案 (Process Findings) を抽出・自動起票。

### 2.5 実行プロファイル層
- **`project.profile.yaml`**: ビルド、テスト、フォーマット等のコマンドを宣言。エージェントが推測で実行することを防ぎます。

### 2.6 コンテキスト管理層
- **`MEMORY.md`**: 現在のタスク、完了事項、次アクション、重要な決定事項を記録。

---

## 3. 動作フロー

`AGENTS.md` で定義された標準フローは以下の通りです。

1. **要望整理** (`request.md`)
2. **調査・分析** (`investigation.md`)
3. **要件確定** (`spec.md`)
4. **実装計画の立案** (`plan.md`)
5. **実装作業**
6. **テスト・検証**
7. **自己レビュー** (`review.md`)
8. **ドキュメント昇格・更新** (`docs/*`, `docs/INDEX.md`)
9. **状態・記憶の更新** (`state.json`, `MEMORY.md`)

このフローを徹底することで、**実装結果とドキュメントの乖離を最小限に抑える**ことができます。

---

## 4. 主な運用ルール

### 4.1 実装前の必須チェック
- `project.profile.yaml` に必要なコマンドが定義されていること。
- 作業対象の `work/<task-id>/` が存在し、`request.md` / `spec.md` / `plan.md` が揃っていること。
- `spec.md` の必須セクションがすべて記入済みであること。

### 4.2 ブロック条件
以下の不備がある場合、作業を継続せず先に是正を行います。
- `spec.md` の必須項目が未記入、または「テスト要件」が具体的でない。
- `plan.md` が `spec.md` を適切に参照していない。
- `docs/INDEX.md` の更新が漏れている。

### 4.3 自己改善ループ (Process Findings)
- `review.md` に作業プロセスの改善点 (`## 6. Process Findings`) を記録します。
- 重大度が `must/high` の項目は、自動ツールを用いてフォローアップタスクとして起票します。

---

## 5. 使用方法

### 5.1 新規タスクの開始
```powershell
$taskId = "2026-02-19__sample-task"
New-Item -ItemType Directory -Path "work/$taskId" -Force
Copy-Item docs/templates/*.md "work/$taskId/"
```
※その後、`request.md`, `spec.md`, `plan.md`, `state.json` を適切に編集します。

### 5.2 整合性チェックの実行
```powershell
pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>
```

### 5.3 インデックスの更新
```powershell
pwsh -NoProfile -File tools/docs-indexer/index.ps1
```

---

## 6. リポジトリ構成 (主要ディレクトリ)
```text
.
├─ AGENTS.md              # 行動規範・正本ルール
├─ MEMORY.md              # 作業コンテキスト・引き継ぎ
├─ project.profile.yaml   # 実行コマンド定義
├─ docs/                  # 永続ドキュメント
│  ├─ INDEX.md            # 全資料インデックス
│  └─ templates/          # ファイルテンプレート
├─ work/                  # タスク別作業ディレクトリ
└─ tools/                 # 自動化ツール群
```

---

## 7. ライセンス
このリポジトリのライセンス方針は、必要に応じてプロジェクトオーナーが別途定義してください。
