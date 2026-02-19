# Investigation: 2026-02-19__rail10-skill-command-path-fix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/request.md`
  - `work/2026-02-19__rail10-skill-command-path-fix/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 1. 調査対象 [空欄禁止]

- `Rail10:list-planned-tasks-by-backlog-priority` の `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` コマンド案内の現状。
- スキル同梱スクリプト `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` の実在と実行導線。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `$HOME` 依存の案内を除去し、スキル同梱 scripts ディレクトリへ到達する案内へ統一すれば、実行再現性が向上する。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
- 実施した確認:
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンド例に "$HOME/.agents/..." と "agents/skills/..." が併記されていることを確認。
  - スクリプト本体が `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` に存在することを確認。
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` が現時点で内容一致していることを確認。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` には実行パス方針が2種類混在している。
- "$HOME/.agents/..." は利用者環境の配置前提を含み、リポジトリ内の実行導線としては冗長。
- スキル同梱 `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1` を起点にした案内で要件を満たせる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクの実装要件は「スキル同梱 scripts ディレクトリを正本導線にする」ことに定義する。
- 受入条件には、"$HOME/.agents/..." 案内の除去と、実行可能な具体コマンドの提示を含める。
- docs 反映範囲は少なくとも `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と task 成果物（`work/2026-02-19__rail10-skill-command-path-fix/review.md` / `work/2026-02-19__rail10-skill-command-path-fix/state.json`）まで含める。

## 6. 未解決事項 [空欄禁止]

- なし（本タスクでは「スキル同梱 scripts 起点」の要件まで確定済み）。

## 7. 次アクション [空欄禁止]

1. `spec.md` に受入条件とテスト要件（Unit/Integration/Regression/Manual）を確定する。
2. `plan.md` に実装順序・検証順序・ロールバックを記述する。
3. high-priority backlog と memory を新規 task 起票状態へ更新する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-19__rail10-skill-command-path-fix/request.md`
- spec: `work/2026-02-19__rail10-skill-command-path-fix/spec.md`

