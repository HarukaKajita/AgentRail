# 自己改善ループ導入調査

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象

- フロー漏れ再発の発生要因
- 既存 checker / CI での検知可能範囲

## 2. 観測

- 既存 `consistency-check` は `spec.md`・`docs/INDEX.md` 中心で、`review.md` の改善事項は検証対象外。
- CI は `docs-indexer` と `check.ps1` を実行しているが、改善起票の有無は判定していない。
- そのため「気づきはあるがタスク化されない」状態が発生しうる。

## 3. 原因

1. Process Findings の標準スキーマが存在しない。
2. `must/high` finding の起票強制ルールが未実装。
3. 改善起票を補助する CLI がない。

## 4. 対策方針

- `review.md` に機械可読スキーマを追加。
- `scan.ps1` と `check.ps1` で重大 finding の未起票を fail-fast 化。
- `create-task.ps1` で follow-up task 雛形を自動生成。

## 5. 参照

- `docs/specs/self-improvement-loop-spec.md`
- `docs/operations/ci-failure-runbook.md`
- `tools/consistency-check/check.ps1`
