---
name: read_profile
description: project.profile.yaml を読み込み、実行に必要なコマンドとチェック条件を抽出する。
---

このスキルは、実行環境差分を吸収するために `project.profile.yaml` を解釈するときに使う。

## いつ使うか

- タスク着手時の事前確認
- テスト計画と実行コマンドの確定時

## 入力

- `project.profile.yaml`
- 対象タスクID

## 出力

- `work/<task-id>/plan.md` に `Execution Commands` セクションを追加・更新
- 必須キーの検証結果
- 不足がある場合は質問リスト

## 禁止事項

- profile にないコマンドを推測して実行しない
- 必須キー不足を無視して進行しない
