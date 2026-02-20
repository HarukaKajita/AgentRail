# AgentRail

AgentRail は、**要望から実装・テスト・レビュー・資料更新までを一貫して固定化**するための、スタック非依存の開発フレームワークです。  
実装コードそのものよりも、**開発プロセスの再現性・追跡可能性・引き継ぎ容易性**と、**人間が短時間で理解できる資料運用**を重視して設計されています。

---

## 1. これは何か

AgentRail は次の問題を解決することを目的にしています。

- 要件・設計・実装の関係が散逸する
- 「作ったが、なぜ作ったか分からない」状態になる
- セッション切り替えや担当交代でコンテキストが失われる
- ドキュメント更新漏れや整合性崩れが発生する

このリポジトリでは、以下 2 つを SSOT として運用します。

- `work/<task-id>/`: 個別タスクの作業正本
- `docs/`: プロジェクト横断の資料バンク（目的/使い方/仕組み/実装/関連情報の導線を維持）

### 1.1 Human-Centric クイック導線

最短で全体像を掴む場合は、次の順に確認します。

1. 目的:
   - `AGENTS.md` の「1. 目的」「7. 完了条件」
2. 使い方:
   - `README.md` の「6. 導入手順」「7. 使用方法」
3. 仕組み:
   - `README.md` の「2. 何で構成されるか」「3. どう動作するか」
4. 実装:
   - `tools/` と `project.profile.yaml`
5. 関連:
   - `docs/INDEX.md` と `docs/operations/high-priority-backlog.md`

---

## 2. 何で構成されるか（全体構成）

### 2.1 ルール層

- `AGENTS.md`
  - このフレームワークの正本ルール
  - 固定ワークフロー、ブロック条件、完了条件を定義
- `CLAUDE.md`
  - 互換用ルール（矛盾時は `AGENTS.md` 優先）

### 2.2 タスク層 (`work/`)

各タスクは `work/<task-id>/` に以下6ファイルを持ちます。

- `request.md`: 要望整理
- `investigation.md`: 調査
- `spec.md`: 要件仕様（受入条件・テスト要件含む）
- `plan.md`: 実装計画
- `review.md`: 検証結果・指摘
- `state.json`: 状態管理 (`planned` / `in_progress` / `done` など)

### 2.3 資料層 (`docs/`)

- `docs/specs/`: 仕様
- `docs/decisions/`: ADR（意思決定記録）
- `docs/investigations/`: 調査記録
- `docs/operations/`: 運用手順・バックログ
- `docs/templates/`: テンプレート
- `docs/INDEX.md`: 全資料の導線

### 2.4 自動化層 (`tools/`)

- `tools/docs-indexer/index.ps1`
  - `docs/INDEX.md` 管理セクションを再生成
- `tools/consistency-check/check.ps1`
  - task 一式の整合チェック（必須ファイル、spec空欄、リンク、review整合など）
- `tools/ci/resolve-task-id.ps1`
  - CI で checker 対象の task-id を解決
- `tools/improvement-harvest/scan.ps1`
  - `review.md` の `Process Findings` を検証・抽出
- `tools/improvement-harvest/create-task.ps1`
  - Process finding から follow-up task 雛形を自動起票

### 2.5 パイプライン層

- `.github/workflows/ci-framework.yml`
  - docs-indexer 実行
  - `docs/INDEX.md` 差分チェック
  - task-id 解決
  - improvement scan + consistency check

### 2.6 実行プロファイル層

- `project.profile.yaml`
  - build/test/format/lint と framework コマンドを宣言
  - エージェントが推測実行しないための実行契約

### 2.7 引き継ぎ層

- `MEMORY.md`
  - 現在タスク、完了事項、次アクション、意思決定の記録

---

## 3. どう動作するか（処理フロー）

`AGENTS.md` で固定された標準フローは次の通りです。

1. 要望整理 (`request.md`)
2. 調査 (`investigation.md`)
3. 要件確定 (`spec.md`)
4. 実装計画 (`plan.md`)
5. 実装
6. テスト
7. レビュー (`review.md`)
8. 資料更新（`docs/*`, `docs/INDEX.md`）
9. 記憶更新（`state.json`, `MEMORY.md`）

この流れにより、**実装結果と資料が乖離しにくい**設計になっています。

---

## 4. 運用ルール

日々の運用では、次のルールを守ります。

### 4.1 実装前チェック

- `project.profile.yaml` が存在し必須キーが埋まっていること
- 対象 `work/<task-id>/` が存在すること
- `request.md` / `spec.md` / `plan.md` / `state.json` が揃っていること
- `spec.md` の空欄禁止セクションが記入済みであること

### 4.2 ブロック条件（先に是正が必要）

- `spec.md` の空欄禁止項目が未記入
- `テスト要件` が検証可能な粒度になっていない
- `plan.md` が `spec.md` を参照していない
- `docs/INDEX.md` 更新漏れ
- `project.profile.yaml` の必須キー不足

### 4.3 完了条件（`done` にする条件）

- `spec.md` の受入条件を満たしている
- テスト結果が `review.md` に記録されている
- 変更に対応する docs が更新されている
- `docs/INDEX.md` に導線がある
- `MEMORY.md` と `state.json` が最新

### 4.4 docs 運用ルール

- `docs/` は資料バンクの SSOT とする
- 新規資料追加時は `docs/INDEX.md` を同時更新する
- `work/<task-id>/` で確定した内容のみ `docs/` へ昇格する
- 重要な判断は `docs/decisions/` に ADR として残す

### 4.5 自己改善ルール

- `review.md` に `## 6. Process Findings` を記録する
- 重大度 `must/high` の finding は `action_required: yes` とし、`linked_task_id` で follow-up task を紐づける
- `tools/improvement-harvest/scan.ps1` と `tools/consistency-check/check.ps1` で機械検証する

### 4.6 旧資料の扱い

- `archive/legacy-documents/` は履歴・草案の隔離領域とし、通常の設計/実装判断では参照しない
- 現行判断は `docs/` と `work/` を正本とする
- 運用ポリシーは `docs/operations/legacy-documents-policy.md` を参照する

---

## 5. 主な機能

### 5.1 ドキュメントインデックス自動更新

`docs-indexer` は `docs/templates|specs|decisions|investigations|operations` を走査し、`docs/INDEX.md` の管理セクションを更新します。

### 5.2 タスク整合チェック

`consistency-check` は、例えば次を検証します。

- `work/<task-id>/` の必須6ファイル
- `spec.md` の空欄禁止項目
- `plan.md` が `spec.md` を参照しているか
- `docs/INDEX.md` 導線整合
- `project.profile.yaml` 必須キー
- `review.md` の Process Findings 整合（条件付き）

### 5.3 自己改善ループ

`review.md` の `## 6. Process Findings` から改善要件を抽出し、必要に応じて follow-up task を作成します。

- `scan.ps1`: finding の形式・必須項目・重大度条件を検証
- `create-task.ps1`: 6ファイル雛形付きで新規 task 起票

### 5.4 CI ガバナンス

CI は毎回、資料更新漏れと task 整合を機械チェックします。

---

## 6. 導入手順

### 6.1 前提条件

- Git
- PowerShell 7+ (`pwsh`)
- GitHub Actions（CI利用時）

### 6.2 セットアップ

```powershell
git clone <this-repo-url>
cd AgentRail
```

```powershell
# profile が読めることを確認
Get-Content -Raw project.profile.yaml
```

```powershell
# docs index を再生成
pwsh -NoProfile -File tools/docs-indexer/index.ps1
```

---

## 7. 使用方法（サンプル付き）

### 7.1 新規タスクを開始する

```powershell
$taskId = "2026-02-19__sample-task"
New-Item -ItemType Directory -Path "work/$taskId" -Force | Out-Null
Copy-Item docs/templates/spec.md "work/$taskId/spec.md"
Copy-Item docs/templates/investigation.md "work/$taskId/investigation.md"
Copy-Item docs/templates/review.md "work/$taskId/review.md"
```

残りの `request.md`, `plan.md`, `state.json` を作成し、`spec.md` を埋めてから実装に進みます。

### 7.2 タスク整合を検証する

```powershell
pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01
```

### 7.3 docs インデックスを更新する

```powershell
pwsh -NoProfile -File tools/docs-indexer/index.ps1
```

### 7.4 Process Findings を検証する

```powershell
pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId 2026-02-18__self-improvement-loop-enforcement
```

### 7.5 finding から follow-up task を起票する

```powershell
pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 `
  -SourceTaskId 2026-02-18__self-improvement-loop-enforcement `
  -FindingId F-001 `
  -Title "Fix CI task resolution" `
  -Severity high `
  -Category ci
```

---

## 8. リポジトリマップ

```text
.
├─ .github/
│  └─ workflows/
│     └─ ci-framework.yml         # Framework CI
├─ agents/
│  └─ skills/                     # エージェントスキル定義
├─ archive/
│  └─ legacy-documents/           # 旧資料（履歴・草案の隔離領域）
├─ docs/
│  ├─ INDEX.md                    # docs全体インデックス
│  ├─ README.md                   # docs運用ルール
│  ├─ templates/                  # 各種テンプレート
│  ├─ specs/                      # 仕様書
│  ├─ decisions/                  # ADR
│  ├─ investigations/             # 調査資料
│  └─ operations/                 # ランブック・バックログ
├─ tools/
│  ├─ docs-indexer/
│  ├─ consistency-check/
│  ├─ ci/
│  └─ improvement-harvest/
├─ work/                          # タスク成果物（task-id単位）
├─ AGENTS.md                      # 正本ルール
├─ CLAUDE.md                      # 互換ガイド
├─ MEMORY.md                      # 引き継ぎメモ
└─ project.profile.yaml           # 実行プロファイル
```

---

## 9. まず読むべき資料

1. `AGENTS.md`
2. `project.profile.yaml`
3. `docs/README.md`
4. `docs/INDEX.md`
5. `docs/operations/runtime-framework-rules.md`
6. 対象タスクの `work/<task-id>/spec.md`

---

## 10. 現在の注意点

- CI task-id 解決は現時点で fallback を持つ実装です（`tools/ci/resolve-task-id.ps1`）。
- fallback 廃止と差分0件時 skip 方針は、起票済みタスクで対応予定です。
  - `work/2026-02-18__ci-task-resolution-no-fallback/`

---

## 11. ライセンス

このリポジトリのライセンス方針は、必要に応じてプロジェクトオーナーが別途定義してください。
