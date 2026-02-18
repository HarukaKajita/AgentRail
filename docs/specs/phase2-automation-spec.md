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

### 3.4 失敗条件

- 必須ファイルの欠落
- 必須キー不足
- リンク切れ
- 参照不整合

### 3.5 受入基準

- 検査項目 1〜5 がすべて PASS のとき終了コード 0
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

## 6. CI 連携ポイント（確定）

- Phase 2 後半（`docs-indexer` と `consistency-check` のローカル安定化完了後）で連携する。
- CI では以下を順に実行する。
  1. `tools/docs-indexer/index.ps1`
  2. `tools/consistency-check/check.ps1 -TaskId <task-id>`

## 7. 次タスクへの引き継ぎ

次タスクでは本仕様を基に、以下を決定してから実装へ進む。

1. checker の適用対象タスクIDの解決方式（引数必須 / 自動推定）
2. CI での `<task-id>` 受け渡し方法
