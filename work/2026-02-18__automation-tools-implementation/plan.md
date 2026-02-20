# Plan: 2026-02-18__automation-tools-implementation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- 主仕様: `work/2026-02-18__automation-tools-implementation/spec.md`
- 設計正本: `docs/specs/automation-tools-design-spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- index docs: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- consistency check (this task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-implementation`
- consistency check (pilot task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`

## 4. 確定実装計画 (Plan Final)

1. `docs-indexer` 実装
2. `consistency-check` 実装
3. `project.profile.yaml` にコマンド追加
4. `docs/specs/automation-tools-design-spec.md` を確定内容へ更新
5. docs-indexer 実行で INDEX 更新
6. checker を 2 タスクへ適用
7. review/state/memory を更新

## 4. 変更対象ファイル

- `tools/docs-indexer/index.ps1`
- `tools/consistency-check/check.ps1`
- `project.profile.yaml`
- `docs/INDEX.md`
- `docs/specs/automation-tools-design-spec.md`
- `docs/specs/automation-tools-implementation-spec.md`
- `docs/investigations/automation-tools-implementation-investigation.md`
- `MEMORY.md`
- `work/2026-02-18__automation-tools-implementation/*`

## 5. リスクとロールバック

- リスク: INDEX 構造変更で script が適用不能になる
- ロールバック: `docs/INDEX.md` を直前コミットへ戻し、見出しパターンを更新する

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS
- checker 2タスク実行が PASS
- `state.json` を `done` に更新
