# Plan: 2026-02-19__task-doc-prerequisite-knowledge-section

## 0. 着手前確定

### 0.1 実装戦略オプション（3案）

1. 速度重視:
   - 新規 task 生成のみ対応し、既存 docs は手動更新を後追いにする。
2. バランス:
   - 新規生成 + checker 追加 + high-priority task から遡及更新する。
3. 拡張重視（採用）:
   - 新規生成 + checker 追加 + active docs/work の遡及更新方針を同一タスクで完了させる。

### 0.2 推奨案

- 採用: オプション3（拡張重視）
- 理由:
  - 目的が「どこから読んでも遡れる状態」であり、部分導入では保証が弱いため。
  - checker 導入と遡及方針を同時確定することで、運用定着を最短化できるため。

### 0.3 確認質問（2〜4件）

- なし（要望から実装方向が十分に確定している）。

### 0.4 blocked 判定

- blocked ではない。

## 1. 対象仕様

- `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`

## 2. Execution Commands

- target task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-doc-prerequisite-knowledge-section`
- all tasks consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. 前提知識セクションの標準フォーマット（見出し、必須項目、path 記法）を決定する。
2. task 5資料の生成経路（テンプレートと起票生成）へ標準フォーマットを適用する。
3. consistency-check に前提知識セクション検証を追加する。
4. active docs/work への遡及更新順序を定め、必要な資料更新を実施する。
5. review と state を更新し、回帰チェックで完了判定を記録する。

## 4. 変更対象ファイル

- `docs/templates/spec.md`
- `docs/templates/investigation.md`
- `docs/templates/review.md`
- `tools/improvement-harvest/create-task.ps1`
- `tools/consistency-check/check.ps1`
- `docs/INDEX.md`
- `docs/specs/*.md`
- `work/*/request.md`
- `work/*/investigation.md`
- `work/*/spec.md`
- `work/*/plan.md`
- `work/*/review.md`
- `work/2026-02-19__task-doc-prerequisite-knowledge-section/review.md`
- `work/2026-02-19__task-doc-prerequisite-knowledge-section/state.json`

## 5. リスクとロールバック

- リスク:
  - 更新対象が広く、競合とレビュー負荷が上がる。
  - 厳格化した checker が暫定的に大量 FAIL を出す可能性がある。
- ロールバック:
  1. checker の新規ルールを feature flag 相当で一時無効化する。
  2. docs/work の更新を対象群ごとに小分けして戻せるようにコミット分割する。
  3. 最小必須セット（新規生成フォーマット）だけを先行確定し、遡及更新を follow-up へ分離する。

## 6. テスト実行順

1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__task-doc-prerequisite-knowledge-section`
2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 7. 完了判定

- AC-001〜AC-005 が `work/2026-02-19__task-doc-prerequisite-knowledge-section/review.md` で PASS 判定になる。
- docs 導線と state 更新が完了している。
