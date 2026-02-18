---
name: Rail8:review-quality-loop
description: work/<task-id>/review.md の記述だけでなく、要件適合・設計品質・セキュリティ・性能をレビューし、改善提案と再レビュー計画まで含む反復改善ループを定義する。
---

# Review Quality Loop

## 役割

レビューを単発の報告で終わらせず、修正と再レビューを繰り返して品質を収束させる。

## 事前参照

- `references/framework-flow.md`
- `references/brainstorming-and-question-patterns.md`
- `work/<task-id>/spec.md`
- `work/<task-id>/plan.md`
- `work/<task-id>/review.md`
- 変更対象コードとテスト結果

## 実行手順

1. 受入条件とテスト結果の達成状況を確認する。
2. ソフトウェア品質観点でレビューする。
   - SOLID, DRY, KISS, YAGNI
   - セキュリティリスク
   - パフォーマンスリスク
   - 保守性・運用性・回帰リスク
3. findings を重大度（must/high/medium/low）で分類する。
4. 改善提案オプションを3案作る（最短収束 / バランス / 強化）。
5. 推奨案を1つ選び、修正対象・期待効果・副作用を示す。
6. `review.md` へ反映する内容を確定する。
7. must/high の finding は follow-up task 接続方針を明示する。
8. 再レビュー計画を作る（確認項目、完了条件、停止条件）。

## 出力フォーマット

1. レビュー観点別の評価結果
2. findings 一覧（重大度・根拠・影響）
3. 改善提案オプション（3案）
4. 推奨案
5. `review.md` 反映案
6. follow-up task 接続方針
7. 再レビュー計画

## 禁止事項

- 要件適合だけでレビュー完了にしない。
- 根拠のない指摘をしない。
- must/high の改善要否を曖昧にしない。

