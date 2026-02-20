# AgentRail Agent Rules

このファイルは AgentRail リポジトリにおけるエージェント作業の正本ルールです。  
Claude 互換の補助は `CLAUDE.md` に記載しますが、矛盾時はこのファイルを優先します。

## 1. 目的

- 要望から資料更新までの工程を固定し、再現可能かつ人間が追従可能な開発を行う。
- SSOT (Single Source of Truth / 単一の正) として `docs/` と `work/` を維持する。
- docs を人間理解の資料バンクとして運用し、目的・使い方・仕組み・実装・関連情報を辿れる状態を維持する。
- 長時間作業でも引き継げるように `MEMORY.md` を更新する。

## 2. 実行前チェック (空欄禁止)

以下を満たさない場合は実装に着手しない。

1. `project.profile.yaml` が存在し、必須キーが埋まっている。
2. 対象タスクの `work/<task-id>/` が存在する。
3. `work/<task-id>/request.md` が作成済み。
4. `work/<task-id>/spec.md` の空欄禁止セクションが埋まっている。
5. `work/<task-id>/plan.md` が作成済み。
6. `work/<task-id>/state.json` が最新状態を示している。
7. `work/<task-id>/state.json` の `depends_on` が最新で、未解決依存を把握できている。
8. `request/investigation/spec/plan/review` に `前提知識` セクションがあり、参照先が解決できる。

## 3. 固定ワークフロー

必ず以下の順序で進行する。

1. 要望整理 (`request.md`)
2. 調査 (`investigation.md`)
3. 要件確定 (`spec.md`)
4. 実装計画ドラフト (`plan.md` の `plan-draft`)
5. 依存解決確認（depends_on gate）
6. 実装計画確定 (`plan-final`)
7. 実装
8. テスト
9. レビュー (`review.md`)
10. 資料更新 (`docs/INDEX.md` と関連資料)
11. 記憶更新 (`MEMORY.md` と `state.json`)

### 3.1 コミット境界 (Commit Boundary)

差分混在を防ぐため、次の境界でコミットを行う。

1. 起票境界コミット:
   - `request.md` / `investigation.md` / `spec.md` / `plan-draft` の要件確定と backlog 登録が完了した時点
2. 実装境界コミット:
   - `depends_on gate` 通過後の `plan-final` 確定、実装とテストが完了し、レビュー前に差分が安定した時点
3. 完了境界コミット:
   - `review.md` / docs / `MEMORY.md` / `state.json` 更新まで完了した時点

コミット前には、stage された差分が単一 task に閉じていることを確認する。

推奨コマンド:
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase kickoff`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase implementation`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase finalize -AllowCommonSharedPaths`

### 3.2 Subagent Delegation Governance

品質維持のため、subagent / multi_agent 委譲は次の契約で運用する。

1. 委譲対象は `request` / `investigation` / `spec` / `plan-draft` に限定する。
2. 4工程は単一 `delegated_agent_id` で連続実行する。
3. 一次成果物は `request.md` / `investigation.md` / `spec.md` / `plan.md`（`plan-draft` 節）へ直接反映する。
4. 委譲実行ごとに sidecar 監査ログ（`work/<task-id>/agent-logs/...`）を残す。
5. 親エージェントは `plan-draft` 完了後に `gate_result=pass|fail` を記録する。
6. `gate_result=pass` まで kickoff commit / depends_on gate / `plan-final` / commit を禁止する。
7. `gate_result=fail` は差し戻しとし、状態は `blocked` または `in_progress` で維持する。
8. `depends_on gate` / `plan-final` / 実装 / テスト / レビュー / docs 更新 / commit は親固定とする。

## 4. 厳格ブロック条件

以下のいずれかに該当した場合は、状態を `blocked` にして先に是正する。

- `spec.md` の空欄禁止項目が未記入。
- `spec.md` の `テスト要件` が抽象的で検証条件になっていない。
- `plan.md` が `spec.md` を参照していない。
- `gate_result=pass` 前に kickoff commit / depends_on gate / `plan-final` / commit へ進もうとしている。
- `plan-final` 確定前に実装へ進もうとしている。
- 着手対象 task の `depends_on` に未完了依存がある。
- active task の資料に `前提知識` セクションがない、または参照先が解決できない。
- レビュー後に `docs/INDEX.md` が未更新。
- `project.profile.yaml` の必須キー不足。
- stage 差分に対象 task 以外の `work/<task-id>/` 変更が混在している。

## 5. タスク成果物の必須セット

各タスクは `work/<task-id>/` に次を揃える。

- `request.md`
- `investigation.md`
- `spec.md`
- `plan.md`
- `review.md`
- `state.json`

`state.json` 必須キー:

- `state`
- `owner`
- `updated_at`
- `blocking_issues`
- `depends_on`

## 6. `project.profile.yaml` の扱い

- ビルド・テスト・フォーマット・Lint の具体コマンドは profile から読む。
- profile 未設定時は推測実行しない。質問を生成して停止する。
- フレームワーク本体は特定技術スタックに依存しない。
- runtime 必須ルールの詳細は `docs/operations/runtime-framework-rules.md` を参照する。
- runtime 要旨:
  - 配布境界の SSOT は `framework.runtime.manifest.yaml`。
  - 導入先 task root の標準は `.agentrail/work`。
  - runtime 関連ツールのパス解決は `workflow.task_root/docs_root/runtime_root` 起点で統一する。

## 7. 完了条件

以下を満たしたときのみ `done` とする。

1. `spec.md` の受入条件をすべて満たした。
2. `テスト要件` の実施結果が `review.md` に記録された。
3. 変更点に対応する docs が更新された。
4. `docs/INDEX.md` に新規・更新資料への導線が追加された。
5. `MEMORY.md` が最新状態に更新された。

## 8. 安全規則

- 明示依頼がない破壊的操作（例: `git reset --hard`, `rm -rf`）は禁止。
- 既存の未関連変更は勝手に取り消さない。
- リスクの高い操作は理由と影響を先に記録する。

## 9. 出力フォーマット

最終報告は最低限次を含む。

1. 実施内容の要約
2. 受入条件の達成状況
3. テスト結果
4. 更新した資料一覧
5. 次アクション
