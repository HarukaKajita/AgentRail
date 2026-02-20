# AgentRail エージェント行動規範 (Agent Rules)

本ファイルは、AgentRail リポジトリにおけるエージェント作業の正本ルールを定義する。  
Claude 互換のための補助ルールは `CLAUDE.md` に記載するが、内容に矛盾がある場合は本ファイルを優先する。

## 1. 目的

- 要望から資料更新に至る全工程を標準化し、再現性と透明性の高い開発プロセスを実現する。
- `docs/`（永続ドキュメント）と `work/`（作業記録）を SSOT (Single Source of Truth / 信頼できる唯一の情報源) として維持する。
- `docs/` を「人間が最短で理解できる資料バンク」として運用し、目的・使用方法・構造・実装・関連情報の導線を常に最新に保つ。
- 作業コンテキストを `MEMORY.md` に継続的に記録し、セッションの中断や引き継ぎを容易にする。

### 1.1 人間中心の閲覧パス (Human-Centric Reading Path)

プロジェクトの全体像を把握する際は、以下の 5 観点を基準に資料を閲覧する。

1. **目的**: `AGENTS.md` の「目的」と「完了条件」を確認する。
2. **使用方法**: `README.md` の実行フローと基本コマンドを確認する。
3. **構造**: `work/<task-id>/` と `docs/` の役割分担と関係性を把握する。
4. **実装**: `tools/` および `project.profile.yaml` の実行定義を参照する。
5. **関連情報**: `docs/INDEX.md` および `docs/operations/high-priority-backlog.md` から周辺資料を辿る。

## 2. 実行前チェック事項 (必須)

以下の条件を満たさない限り、実装作業に着手してはならない。

1. `project.profile.yaml` が存在し、必須項目がすべて定義されている。
2. 作業対象となるタスクディレクトリ `work/<task-id>/` が存在する。
3. `work/<task-id>/request.md`（要望整理）が作成されている。
4. `work/<task-id>/spec.md`（要件仕様）の必須セクションがすべて記入されている。
5. `work/<task-id>/plan.md`（実装計画）が作成されている。
6. `work/<task-id>/state.json` が最新の状態を反映している。
7. `state.json` の `depends_on`（依存関係）が定義され、未解決の依存がないことを確認している。
8. 各資料に「前提知識」セクションがあり、必要な参照先が明記されている。

## 3. 標準ワークフロー

すべてのタスクは、例外なく以下の順序で進行する。

1. 要望整理 (`request.md`)
2. 調査・分析 (`investigation.md`)
3. 要件確定 (`spec.md`)
4. 実装計画ドラフト作成 (`plan.md` 内の `plan-draft`)
5. 依存関係の解決確認 (Depends-on Gate)
6. 実装計画の確定 (`plan-final`)
7. 実装作業
8. テスト・検証
9. 自己レビューと記録 (`review.md`)
10. ドキュメント更新 (`docs/` 配下および `docs/INDEX.md`)
11. 進捗・記憶の更新 (`MEMORY.md` および `state.json`)

### 3.1 コミット境界 (Commit Boundary)

作業の独立性と追跡可能性を確保するため、以下の境界でコミットを行う。

1. **起票境界 (Kickoff Commit)**:
   - 要件確定 (`spec.md`)、計画ドラフト (`plan-draft`)、バックログ登録が完了した時点。
2. **実装境界 (Implementation Commit)**:
   - 実装計画の確定、コードの実装、およびテストが完了し、レビュー前の状態が安定した時点。
3. **完了境界 (Finalize Commit)**:
   - レビュー記録 (`review.md`)、関連ドキュメント (`docs/`)、状態管理 (`state.json`, `MEMORY.md`) の更新がすべて完了した時点。

コミット前には、ステージングされた差分が対象タスクの範囲内に収まっていることを必ず確認する。

#### 推奨検証コマンド:
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase kickoff`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase implementation`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase finalize -AllowCommonSharedPaths`

### 3.2 サブエージェント委譲ガバナンス (Subagent Delegation Governance)

品質維持のため、サブエージェント（またはマルチエージェント）への委譲は以下の制約下で運用する。

1. 委譲対象工程は `request`, `investigation`, `spec`, `plan-draft` に限定する。
2. これら 4 工程は、単一の `delegated_agent_id` で連続して実行する。
3. 成果物は各 Markdown ファイルへ直接反映する。
4. 実行ごとに監査ログ (`work/<task-id>/agent-logs/`) を記録する。
5. 親エージェントは、計画ドラフト完了後に内容を精査し `gate_result=pass|fail` を記録する。
6. `gate_result=pass` が記録されるまで、以降の工程（コミット、実装等）へ進むことを禁止する。
7. `gate_result=fail` の場合は差し戻しとし、状態を `blocked` または `in_progress` で維持する。
8. 重要な判断を伴う工程（実装、テスト、レビュー、ドキュメント更新、最終コミット）は親エージェントが自ら実行する。

## 4. 厳格なブロック条件 (Blocking Conditions)

以下の項目に抵触する場合、タスク状態を `blocked` とし、作業を中断して反映を最優先する。

- `spec.md` の必須項目が未記入、または内容が不十分である。
- `spec.md` の「テスト要件」が具体的でなく、客観的な検証が不可能である。
- `plan.md` が `spec.md` の要件を適切に参照していない。
- `gate_result=pass` の承認前に次の工程に進もうとしている。
- `plan-final`（確定計画）の作成前に実装を開始している。
- 依存する未完了タスクが存在する。
- 資料に「前提知識」セクションが欠落している、または参照先が不明である。
- レビュー完了後に `docs/INDEX.md` が更新されていない。
- `project.profile.yaml` に必要な設定が不足している。
- ステージングされた差分に対象外のタスクの変更が含まれている。

## 5. タスク成果物の構成

各タスクディレクトリ `work/<task-id>/` には、以下のファイルを完備しなければならない。

- `request.md` (要望整理)
- `investigation.md` (調査・分析)
- `spec.md` (要件仕様)
- `plan.md` (実装計画)
- `review.md` (レビュー・検証結果)
- `state.json` (状態管理データ)

### `state.json` の必須キー:
- `state`, `owner`, `updated_at`, `blocking_issues`, `depends_on`

## 6. 実行プロファイル (`project.profile.yaml`) の運用

- ビルド、テスト、フォーマット、静的解析等の具体的コマンドは、すべて本プロファイルから取得する。
- プロファイルに未定義のコマンドを推測で実行してはならない。不明な場合はユーザーに確認する。
- 本フレームワーク自体は特定の技術スタックを強制しない。
- 実行環境のルール詳細は `docs/operations/runtime-framework-rules.md` を参照すること。

## 7. 完了条件 (Done Criteria)

以下のすべての条件を満たした場合に限り、タスクを `done` 状態とする。

1. `spec.md` に定義された「受入条件」をすべて達成した。
2. 「テスト要件」に基づく検証結果が `review.md` にすべて記録された。
3. 変更内容を反映したドキュメント (`docs/`) が適切に更新された。
4. `docs/INDEX.md` に新しい資料への導線が追加された。
5. `MEMORY.md` および `state.json` が最新の状態に更新された。

## 8. 安全規則

- 破壊的な操作（`git reset --hard`, `rm -rf` 等）は、ユーザーの明示的な指示がない限り禁止する。
- 進行中のタスクに関係のない既存の変更を独断で修正・削除してはならない。
- リスクを伴う操作を実行する場合は、事前にその理由と影響範囲を記録・報告する。

## 9. 出力フォーマット (Reporting Format)

最終報告には、最低限以下の内容を含めること。

1. 実施内容の要約
2. 受入条件の達成状況
3. テスト・検証結果
4. 更新したドキュメントの一覧
5. 次に推奨されるアクション
