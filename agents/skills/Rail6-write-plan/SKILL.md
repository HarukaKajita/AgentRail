---
name: Rail6:write-plan
description: 確定済み spec.md を参照して work/<task-id>/plan.md を作成・更新し、提案3案と確認質問2-4件を含む実装順序・検証順序・ロールバック方針を決定する。
---

# Write Plan

## 役割

`spec.md` を実行可能な工程へ分解し、順序と検証を固定する。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/spec.md`
- `project.profile.yaml`
- 関連 docs / tools

## 実行手順

1. `spec.md` 参照有無と空欄禁止充足を確認する。
2. 実装戦略オプションを3案作る（速度重視 / バランス / 拡張重視）。
3. 推奨案を選び、実施ステップを時系列で作る。
4. 変更対象ファイル、リスク、ロールバック方針を定義する。
5. profile ベースのテスト実行順を定義する。
6. 高影響の不確定点のみ確認質問 2〜4 件を提示する。
7. 実装開始不能なら `blocked` を提案する。
8. 実装着手前に、起票境界コミット完了を確認する。
   - `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId <task-id> -Phase kickoff`

## 出力フォーマット

1. 実装戦略オプション（3案）
2. 推奨案
3. 実施ステップ
4. リスクとロールバック
5. テスト実行順
6. 確認質問（2〜4件）
7. blocked 判定

## 禁止事項

- `spec.md` 非参照で計画を作らない。
- 影響範囲の未記載を許容しない。
- 計画作成と同時に実装を開始しない。


