# Plan: 2026-02-18__phase2-automation-implementation

## 1. 対象仕様

- 主仕様: `work/2026-02-18__phase2-automation-implementation/spec.md`
- 設計正本: `docs/specs/phase2-automation-spec.md`

## 2. Execution Commands

- index docs: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- consistency check (this task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__phase2-automation-implementation`
- consistency check (pilot task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`

## 3. 実施ステップ

1. `docs-indexer` 実装
2. `consistency-check` 実装
3. `project.profile.yaml` にコマンド追加
4. `docs/specs/phase2-automation-spec.md` を確定内容へ更新
5. docs-indexer 実行で INDEX 更新
6. checker を 2 タスクへ適用
7. review/state/memory を更新

## 4. 変更対象ファイル

- `tools/docs-indexer/index.ps1`
- `tools/consistency-check/check.ps1`
- `project.profile.yaml`
- `docs/INDEX.md`
- `docs/specs/phase2-automation-spec.md`
- `docs/specs/phase2-implementation-spec.md`
- `docs/investigations/phase2-implementation-investigation.md`
- `MEMORY.md`
- `work/2026-02-18__phase2-automation-implementation/*`

## 5. リスクとロールバック

- リスク: INDEX 構造変更で script が適用不能になる
- ロールバック: `docs/INDEX.md` を直前コミットへ戻し、見出しパターンを更新する

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS
- checker 2タスク実行が PASS
- `state.json` を `done` に更新
