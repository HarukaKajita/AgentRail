# Plan: 2026-02-18__self-improvement-loop-enforcement

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__self-improvement-loop-enforcement/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- scan: `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId 2026-02-18__self-improvement-loop-enforcement`
- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__self-improvement-loop-enforcement`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`

## 4. 確定実装計画 (Plan Final)

1. Process Findings スキーマとテンプレートを追加する。
2. `tools/improvement-harvest/scan.ps1` と `tools/improvement-harvest/create-task.ps1` を実装する。
3. `tools/consistency-check/check.ps1` に改善ゲートを追加する。
4. CI workflow と運用ドキュメントを更新する。
5. 手動検証を実施して review/state を更新する。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `tools/improvement-harvest/scan.ps1`
- `tools/improvement-harvest/create-task.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/templates/review.md`
- `docs/specs/*.md`
- `docs/operations/*.md`
- `work/2026-02-18__self-improvement-loop-enforcement/*`

## 5. リスクとロールバック

- リスク: finding 書式解釈の不一致で誤検知する。
- ロールバック: 追加ルールを一時的に無効化し、parserを修正して再適用する。

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS
- CI とローカル検証コマンドが成功
