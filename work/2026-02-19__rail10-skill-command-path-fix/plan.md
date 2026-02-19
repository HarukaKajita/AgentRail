# Plan: 2026-02-19__rail10-skill-command-path-fix

## 0. 着手前確定

### 0.1 テスト設計オプション

1. 最小: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` 文言の置換確認のみを行う。
2. 標準（採用）: 文言確認 + 実行例コマンドの実行確認を行う。
3. 強化: 標準 + `.agents/` と `agents/` の内容一致チェックを自動化する。

採用理由:
- 文書修正タスクでも「記載コマンドが実行できること」を保証するため。

### 0.2 docs 更新オプション

1. 最小: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のみ更新する。
2. 標準（採用）: `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` + `review.md` + `state.json` を更新する。
3. 強化: 標準 + スキル運用ガイド全体を横断更新する。

採用理由:
- 受入条件と完了状態を task 成果物に明示し、追跡可能性を確保するため。

### 0.3 推奨案

- テストは 0.1-2（標準）を採用し、両ディレクトリ存在時は 0.1-3 相当の一致確認を追加実施する。
- docs 更新は 0.2-2（標準）を採用する。

### 0.4 確認質問（2〜4件）

- なし。要望で「起票 + 要件確定 + コミット」が明示されているため。

### 0.5 blocked 判定

- `blocked` ではない（必須成果物作成前提を満たしている）。

## 1. 対象仕様

- `work/2026-02-19__rail10-skill-command-path-fix/spec.md`

## 2. Execution Commands

- forbidden path check:
  - `rg -n '\$HOME/\.agents/skills' .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- script reference check:
  - `rg -n 'scripts/list_planned_tasks\.ps1' .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- execution check (skill-local):
  - `pwsh -NoProfile -File .agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1 -RepoRoot .`
- consistency check:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__rail10-skill-command-path-fix`

## 3. 実施ステップ

1. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` のコマンドセクションをスキル同梱 scripts 起点へ統一する。
2. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` と `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` の双方が存在する場合は同内容へ同期する。
3. Unit/Integration 相当のコマンド確認を行う。
4. `review.md` に検証結果を記録し、`state.json` を `done` へ更新する。

## 4. 変更対象ファイル

- `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
- `agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`（存在する場合）
- `work/2026-02-19__rail10-skill-command-path-fix/review.md`
- `work/2026-02-19__rail10-skill-command-path-fix/state.json`

## 5. リスクとロールバック

- リスク:
  - コマンド例の更新だけで満足し、実行性確認が漏れる。
  - 二重配置ディレクトリの片側のみ更新される。
- ロールバック:
  1. `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md` を直前コミットへ戻す。
  2. `review.md` / `state.json` を PENDING 状態へ戻す。
  3. 要件（spec）と実行結果を再照合して再実装する。

## 6. 完了判定

- AC-001〜AC-005 が `review.md` で PASS 判定になる。
- `tools/consistency-check/check.ps1` が PASS する。
- `state.json` が `done` に更新される。
