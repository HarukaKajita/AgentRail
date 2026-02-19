# Request: 2026-02-18__self-improvement-loop-enforcement

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- 漏れ再発を防ぐため、作業フローで自己改善を強制する仕組みを実装する。

## 要望の整理

- `review.md` の Process Findings を機械可読化する。
- must-high finding を必ず改善タスクへ接続する。
- CI で未起票を fail-fast する。
- 起票補助コマンドを用意する。

## 成功条件（要望レベル）

1. `tools/improvement-harvest/scan.ps1` が review findings を検証・抽出できる。
2. `tools/consistency-check/check.ps1` が改善ゲートを検知できる。
3. CI が改善ゲート違反を merge 前に停止できる。
4. follow-up task を自動起票できる。
