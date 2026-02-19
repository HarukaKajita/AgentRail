# docs ディレクトリ運用ガイド

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


`docs/` は SSOT (Single Source of Truth / 単一の正) を保持する資料バンクです。  
仕様・意思決定・調査結果を分散させず、必ずこの配下に保存します。

## 構成

- `INDEX.md`: 全資料への導線
- `templates/`: 作成テンプレート
- `specs/`: 要件仕様
- `decisions/`: ADR (Architecture Decision Record / アーキテクチャ意思決定記録)
- `investigations/`: 調査記録
- `operations/`: 運用手順・ランブック・バックログ

## 運用ルール

1. 新規資料を追加したら `INDEX.md` を同時更新する。
2. 既存資料を変更した場合は、関連資料リンクの整合を確認する。
3. `work/<task-id>/` で確定した内容のみ docs に昇格する。
4. `templates/` を直接運用資料として使わない。
5. 重要な設計・運用判断は `decisions/` に ADR として残す。
6. `review.md` は `done` 判定前に `## 6. Process Findings` を含め、重大度 `must/high` は必ず改善タスクへ接続する。

## 完了判定との関係

以下のいずれかを満たさない変更は未完了扱いです。

- 変更内容に対応する docs が更新されている。
- `INDEX.md` に追加・更新資料の導線がある。
