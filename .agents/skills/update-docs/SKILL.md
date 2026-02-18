---
name: update-docs
description: 実装結果とレビュー結果を docs に反映し、docs/INDEX.md と関連リンクを整合させる。更新方針は提案3案と確認質問2-4件で確定する。
---

# Update Docs

## 役割

レビュー結果を根拠に docs を更新し、資料バンクを最新化する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/spec.md`
- `work/<task-id>/review.md`
- `docs/INDEX.md`

## 実行手順

1. 変更点と根拠資料を抽出する。
2. docs 反映オプションを3案作る（最小更新 / 標準更新 / 詳細更新）。
3. 推奨案を選び、更新対象を確定する。
4. `docs/INDEX.md` の導線更新を必須で含める。
5. Process Findings の must/high がある場合は follow-up task 接続を確認する。
6. 判断に必要な確認質問を 2〜4 件提示する。
7. 根拠不足で確定不能なら `blocked` を提案する。

## 出力フォーマット

1. docs 反映オプション（3案）
2. 推奨案
3. 更新対象ファイル一覧
4. INDEX 更新内容
5. 確認質問（2〜4件）
6. blocked 判定

## 禁止事項

- `docs/INDEX.md` 未更新で完了扱いにしない。
- 根拠のない要約を docs へ昇格しない。
- 実装コード変更を混在させない。

