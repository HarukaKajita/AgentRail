# Request: 2026-02-19__rail10-skill-command-path-fix

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/request.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 要望の原文

- `list-planned-tasks-by-backlog-priority` スキルの `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` に、"$HOME/.agents/..." の PowerShell スクリプト実行案内がある。
- スキル自身の scripts ディレクトリにある PowerShell スクリプトを実行する案内へ修正するタスクを起票してほしい。
- 要件確定完了してタスク起票できたらコミットしてほしい。

## 要望の整理

- 背景:
  - `Rail10:list-planned-tasks-by-backlog-priority` のコマンド案内に、実行基準が混在している。
  - "$HOME/.agents/..." 依存の案内は、利用環境によって再現しにくい。
- 目的:
  - コマンド案内を「スキル同梱 scripts ディレクトリを直接実行する」方針に統一する実装タスクを起票する。
  - 実装前に受入条件・テスト要件・docs 更新範囲を確定する。
- 非要求:
  - 本リクエストでは `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` 自体の実装修正は行わない（起票と要件確定まで）。

## 成功条件（要望レベル）

1. `work/2026-02-19__rail10-skill-command-path-fix/` に必須6ファイルが作成される。
2. `spec.md` が空欄禁止項目を満たし、受入条件とテスト要件が検証可能な粒度で確定される。
3. `docs/operations/high-priority-backlog.md` に本タスクが `planned` として追加される。
4. 起票差分がコミットされる。

