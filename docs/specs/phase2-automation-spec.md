# Phase 2 自動化仕様（設計）

## 1. 目的

Phase 1 の手動運用を補助するため、以下 2 機能の自動化仕様を定義する。

1. `docs-indexer`
2. `consistency-check`

本ドキュメントは Phase 2 の設計正本であり、実装結果は `docs/specs/phase2-implementation-spec.md` に記録する。

## 2. docs-indexer 仕様

### 2.1 入力

- `docs/` 配下の Markdown ファイル一覧
- 既存 `docs/INDEX.md`

### 2.2 出力

- 更新済み `docs/INDEX.md`
- 変更サマリ（追加/更新/削除エントリ）

### 2.3 振る舞い

1. `docs/specs`, `docs/decisions`, `docs/investigations`, `docs/templates` を走査する
2. カテゴリごとにリンクを再構成する
3. 既存手動記述を壊さず、管理セクションのみ更新する

### 2.4 失敗条件

- `docs/INDEX.md` が存在しない
- パース不能な Markdown がある
- 同名エントリ衝突が解決できない

### 2.5 受入基準

- 走査対象が 0 件でない場合、INDEX に全件反映される
- 同じ入力で複数回実行しても差分が発生しない（冪等）

## 3. consistency-check 仕様

### 3.1 入力

- `work/<task-id>/` 一式
- `docs/INDEX.md`
- `project.profile.yaml`

### 3.2 出力

- チェック結果レポート（PASS/FAIL）
- 失敗一覧（ルールID、対象ファイル、理由）
- 終了コード（成功 0 / 失敗 1）

### 3.3 検査項目

1. `spec.md` 空欄禁止項目の未記入検知
2. `テスト要件` の必須サブセクション存在確認
3. `plan.md` が `spec.md` を参照しているか
4. `docs/INDEX.md` に新規 docs 導線があるか
5. `project.profile.yaml` 必須キー充足
6. `review.md` の `Process Findings` 構造検証
7. `must/high` finding の改善タスク接続検証

### 3.4 失敗条件

- 必須ファイルの欠落
- 必須キー不足
- リンク切れ
- 参照不整合

### 3.5 受入基準

- 検査項目 1〜7 がすべて PASS のとき終了コード 0
- いずれか FAIL のとき終了コード 1 と詳細レポートを返す

## 4. 実装方式（確定）

- 採用言語: PowerShell
- 理由:
  - 追加依存なしで現行環境に即時導入できる
  - 既存 `project.profile.yaml` の実行方式と整合する
  - 初期導入コストが最も低い

## 5. コマンド名（確定）

- `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId <task-id> -FindingId <finding-id> -Title <title> -Severity <severity> -Category <category>`

## 6. CI 連携ポイント（確定）

- Phase 2 後半として GitHub Actions へ連携済み（`.github/workflows/ci-framework.yml`）。
- CI では以下を順に実行する。
  1. `tools/docs-indexer/index.ps1 -Mode check`（差分があれば失敗）
  2. `tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
  3. `tools/ci/resolve-task-id.ps1` で task-id を解決（manual優先、差分ベース、0件時は `skip`）
  4. `resolved_task_source != skip` の場合のみ `tools/improvement-harvest/scan.ps1 -TaskId <resolved-task-id>` を実行
  5. `resolved_task_source != skip` の場合のみ `tools/consistency-check/check.ps1 -TaskId <resolved-task-id>` を実行

## 7. 次タスクへの引き継ぎ

次タスクでは本仕様を基に、以下を決定してから実装へ進む。

1. checker を単一最新taskから複数task走査へ拡張するかどうか
2. checker の JSON 出力オプションを追加するかどうか
3. 自己改善起票の運用結果を踏まえて閾値（must/high固定）を見直すかどうか
