# Skills Framework Flow Guide

## 目的

`agents/skills` で開発するスキルが、実運用時 (`./.agents/skills`) にも同一品質で動作するための設計・運用ルールを定義する。

## ディレクトリ責務

- `agents/skills`: リポジトリ管理下の開発用スキル
- `.agents/skills/<skill-name>`: 同期後に実行環境で読み込ませる運用用スキル

開発は `agents/skills` で行い、反映は `tools/skills-sync/sync.ps1` で同期する。

## スキル一覧とフロー上の役割

1. `ask_user_questions`
- フロー位置: 要望整理〜調査
- 役割: 不足情報の質問化、blocked 判定、提案オプション作成

2. `read_profile`
- フロー位置: 実装前チェック、テスト計画
- 役割: `project.profile.yaml` の必須キー検証と実行コマンド抽出

3. `write_spec`
- フロー位置: 要件確定
- 役割: `spec.md` の空欄禁止項目充足、AC とテスト要件の対応定義

4. `write_plan`
- フロー位置: 実装計画
- 役割: `spec.md` を参照した実施順序・リスク・ロールバック定義

5. `write_test_requirements`
- フロー位置: 要件確定〜テスト準備
- 役割: AC を検証可能なテスト要件へ分解

6. `update_docs`
- フロー位置: レビュー後〜資料更新
- 役割: docs 本体と `docs/INDEX.md` の整合更新

7. `list-planned-tasks-by-backlog-priority`
- フロー位置: 着手前の優先度判断
- 役割: backlog と `state.json` の planned 状態照合

## 共通設計ルール

### 1. フロー準拠

全スキルは `AGENTS.md` の固定順序に従う。

- 要望整理
- 調査
- 要件確定
- 実装計画
- 実装
- テスト
- レビュー
- 資料更新
- 記憶更新

順序を飛ばす提案はしない。

### 2. ブロック条件の統一

次を検出した場合は `state=blocked` を提案する。

- `spec.md` 空欄禁止項目の未記入
- テスト要件の抽象化
- `plan.md` の `spec.md` 非参照
- `docs/INDEX.md` 更新漏れ
- `project.profile.yaml` 必須キー不足

### 3. ブレインストーミング出力の統一

ユーザー要求を受けたら、最低限以下を出力する。

1. 提案オプション 3 案
2. 推奨案 1 件
3. 確認質問 2〜4 件
4. 次アクション

各提案に「期待効果 / コスト / リスク」を含める。

### 4. 質問品質の統一

確認質問は「回答で判断が変わるもの」だけを扱う。

- 影響度順に並べる
- 意味の薄い質問を増やさない
- 推測で埋められない内容だけ質問する

## 共通参照ファイルの扱い

実運用はスキル単位で自己完結させる。

そのため、共通ガイドは各スキル配下の `references/` に同一内容を配置する。

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`

## 変更時チェックリスト

1. 変更対象スキルの `SKILL.md` を更新した。
2. `references/` の共通内容整合を確認した。
3. 必要なら `scripts/` を更新した。
4. `tools/skills-sync/sync.ps1 -WhatIf` で同期差分を確認した。
5. docs と `docs/INDEX.md` の導線を更新した。
