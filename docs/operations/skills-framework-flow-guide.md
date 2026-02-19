# Skills Framework Flow Guide

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

`agents/skills` で開発するスキルが、実運用時 (`./.agents/skills`) にも同一品質で動作するための設計・運用ルールを定義する。

## ディレクトリ責務

- `agents/skills`: リポジトリ管理下の開発用スキル
- `.agents/skills/<skill-name>`: 同期後に実行環境で読み込ませる運用用スキル

開発は `agents/skills` で行い、反映は `tools/skills-sync/sync.ps1` で同期する。

## スキル一覧とフロー上の役割

1. `Rail1:write-request`
- フロー位置: 要望整理
- 役割: 要望の具体化、拡張提案、分割提案により `request.md` の粒度を適正化

2. `Rail2:ask-user-questions`
- フロー位置: 要望整理〜調査
- 役割: 不足情報の質問化、blocked 判定、提案オプション作成

3. `Rail3:write-investigation`
- フロー位置: 調査
- 役割: 仮説・調査方法（観測方法）・調査結果（観測結果）・結論を `investigation.md` に確定

4. `Rail4:read-profile`
- フロー位置: 実装前チェック、テスト計画
- 役割: `project.profile.yaml` の必須キー検証と実行コマンド抽出

5. `Rail5:write-spec`
- フロー位置: 要件確定
- 役割: `spec.md` の空欄禁止項目充足、AC とテスト要件の対応定義

6. `Rail6:write-plan`
- フロー位置: 実装計画（`plan-draft` / `plan-final`）
- 役割: `spec.md` を参照した実施順序・リスク・ロールバックを、依存ゲート前後の2段階で定義

7. `Rail7:write-test-requirements`
- フロー位置: 要件確定〜テスト準備
- 役割: AC を検証可能なテスト要件へ分解

8. `Rail8:review-quality-loop`
- フロー位置: レビュー〜改善ループ
- 役割: 要件適合に加えて SOLID/DRY/KISS/YAGNI、セキュリティ、性能をレビューし、改善提案と再レビュー計画を確定

9. `Rail9:update-docs`
- フロー位置: レビュー後〜資料更新
- 役割: docs 本体と `docs/INDEX.md` の整合更新

10. `Rail10:list-planned-tasks-by-backlog-priority`
- フロー位置: 着手前の優先度判断
- 役割: backlog と `state.json` の planned 状態・`depends_on` を照合し、依存解決済み task を優先提示

11. `Commit Boundary Check`
- フロー位置: 各作業境界コミット直前
- 役割: stage 差分が単一 task に閉じていることを検証し、混在を fail-fast する

## 共通設計ルール

### 1. フロー準拠

全スキルは `AGENTS.md` の固定順序に従う。

- 要望整理
- 調査
- 要件確定
- 実装計画ドラフト（`plan-draft`）
- 依存関係ゲート（depends_on gate）
- 実装計画確定（`plan-final`）
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
- stage 差分に対象 task 以外の `work/<task-id>/` が混在
- 着手対象 task の `depends_on` に `state != done` の依存先がある
- active task の資料に `前提知識` セクションが不足している

### 2.1 コミット境界の統一

全スキル運用で次の境界コミットを前提とする。

1. 起票境界コミット
2. 実装境界コミット
3. 完了境界コミット

境界ごとの前提:

- 起票境界コミット: `request.md` / `investigation.md` / `spec.md` / `plan-draft` が確定済みであること。
- 実装境界コミット: depends_on gate pass 後に `plan-final` が確定し、実装とテストが完了していること。
- 完了境界コミット: `review.md` / docs / `MEMORY.md` / `state.json` の更新が完了していること。

コミット前の推奨チェック:

```powershell
pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase kickoff
pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase implementation
pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase finalize -AllowCommonSharedPaths
```

### 2.2 依存関係ゲート

着手時は `state.json` の `depends_on` を必ず確認し、未解決依存がある task は `plan-final` へ進めない。

- ready 判定: `depends_on` が空、または依存先がすべて `state=done`
- blocked-by-dependency 判定: 依存先に `state!=done` が1件以上ある
- fail 条件: 自己依存・循環依存・不存在 task-id 参照
- `plan-draft` は gate 前の探索用計画として扱い、実装/コミット判断に使わない
- `plan-final` は gate pass 後のみ確定する

### 2.3 Subagent Delegation Governance

subagent / multi_agent を使う場合は、品質担保のため次の契約を適用する。

1. 委譲対象は `request` / `investigation` / `spec` / `plan-draft` に限定する。
2. 4工程は同一 `delegated_agent_id` で連続実行する。
3. 一次成果物は `request.md` / `investigation.md` / `spec.md` / `plan.md`（`plan-draft` 節）へ直接反映する。
4. 委譲実行ごとに sidecar 監査ログ（`work/<task-id>/agent-logs/...`）を残す。
5. 親は `plan-draft` 完了後に `gate_result` を判定し、`pass` 前は kickoff commit / depends_on gate / `plan-final` / commit を禁止する。
6. `gate_result=fail` は差し戻しとし、状態を `blocked` または `in_progress` で維持する。
7. `depends_on gate` / `plan-final` / 実装 / テスト / レビュー / docs 更新 / commit は親固定とする。

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
