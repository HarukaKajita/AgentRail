# 仕様書: 2026-02-19__rail10-skill-command-path-fix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/request.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__rail10-skill-command-path-fix`
- タイトル: Rail10 Skill Command Path Fix
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__rail10-skill-command-path-fix/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `Rail10:list-planned-tasks-by-backlog-priority` の `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` では、"$HOME/.agents/..." と "agents/skills/..." の実行例が混在している。
- 目的: スキル同梱 `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` を実行導線の正本として案内を統一し、利用者の再現性を高める。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `Rail10:list-planned-tasks-by-backlog-priority` の `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` コマンドセクションを更新する。
- コマンド案内から "$HOME/.agents/..." 依存を除去し、スキル同梱 scripts ディレクトリを起点とした実行例へ統一する。
- 必要に応じて `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` を同一内容で更新する。
- 実行例コマンドが現在のリポジトリで実行可能であることを検証し、結果を `review.md` に記録する。

### 3.2 Out of Scope [空欄禁止]

- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` 自体のロジック変更。
- 高優先バックログ判定ロジックの変更。
- 本タスク以外のスキル文書一括修正。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンドセクションに "$HOME/.agents/..." の実行案内が存在しない。
- AC-002: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンド例が、スキル同梱 `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` を実行する形で記述される。
- AC-003: 実行例コマンドを実行すると、planned task 一覧を表示できる。
- AC-004: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` が併存する場合、内容差分が生じない。
- AC-005: `review.md` にテスト結果が記録され、`state.json` が完了状態へ更新される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` コマンド記述（文字列仕様）
- 観点:
  - "$HOME/.agents" パス案内が除去されている。
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` 実行案内が存在する。
- 合格条件: 検索結果で禁止文字列が0件、想定コマンド文字列が1件以上。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: コマンド案内と `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` の実行連携
- 観点:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` 記載コマンドをそのまま実行してスクリプトが終了コード0で完了する。
  - 出力に `Planned Tasks` セクションが含まれる。
- 合格条件: 終了コード0かつ出力形式が要件を満たす。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: task 成果物整合 (`tools/consistency-check/check.ps1`)
- 観点: 本タスク文書更新後も必須成果物整合ルールを満たす。
- 合格条件: `check.ps1 -TaskId 2026-02-19__rail10-skill-command-path-fix` が PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンドセクションを確認し、"$HOME/.agents" 依存案内がないことを確認する。
  2. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` 記載コマンドを実行し、planned task 一覧が表示されることを確認する。
  3. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` の双方が存在する場合、内容一致を確認する。
  4. `review.md` と `state.json` が最終状態に更新されていることを確認する。
- 期待結果: 受入条件 AC-001〜AC-005 を満たす。

### 5.5 AC-テスト対応表 [空欄禁止]

- AC-001: Unit Test + Manual Verification-1
- AC-002: Unit Test + Manual Verification-1
- AC-003: Integration Test + Manual Verification-2
- AC-004: Unit Test + Manual Verification-3
- AC-005: Regression Test + Manual Verification-4

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`（存在する場合）
- 影響する仕様・運用資料:
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/review.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/state.json`
- 非機能影響:
  - スキル実行手順の再現性向上
  - 環境依存説明の削減

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 既存スクリプトの処理仕様は変更しない。
  - スキルの説明文は利用者がそのまま実行できる具体度を維持する。
- 想定リスク:
  - コマンド例の更新漏れにより、古い導線が残る。
  - `.agents` と `agents` の二重管理で記載差分が再発する。
- 回避策:
  - `rg` で禁止文字列を検索し、0件確認をレビューに記録する。
  - 両パス存在時は内容一致確認をテスト手順へ組み込む。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__rail10-skill-command-path-fix/request.md`
- investigation: `work/2026-02-19__rail10-skill-command-path-fix/investigation.md`
- plan: `work/2026-02-19__rail10-skill-command-path-fix/plan.md`
- review: `work/2026-02-19__rail10-skill-command-path-fix/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`

