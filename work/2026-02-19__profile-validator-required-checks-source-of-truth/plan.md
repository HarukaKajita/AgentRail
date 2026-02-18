# Plan: 2026-02-19__profile-validator-required-checks-source-of-truth

## 1. 対象仕様

- work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md

## 2. Execution Commands

- consistency: pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-required-checks-source-of-truth
- index update: pwsh -NoProfile -File tools/docs-indexer/index.ps1

## 3. 実施ステップ

1. finding の再現条件を確認する。
2. 対応実装を行う。
3. docs と review を更新する。
4. consistency-check を実行する。

## 4. 変更対象ファイル

- 実装時に確定

## 5. リスクとロールバック

- リスク: finding の再現条件を取り違える
- ロールバック: 直前コミットへ戻し、要件を再確認する

## 6. 完了判定

- AC-001 と AC-002 が PASS
- spec.md と review.md が最新化されている
