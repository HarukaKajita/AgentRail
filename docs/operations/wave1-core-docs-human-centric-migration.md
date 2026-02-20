# Wave 1 Core Docs: Human-Centric Migration

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `docs/operations/wave0-doc-ownership-and-update-matrix.md`
  - `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/spec.md`
- 理解ポイント:
  - 本資料は core docs（`AGENTS.md` / `README.md` / `docs/INDEX.md`）への Wave 1 適用結果を記録する。

## 1. 目的

- Wave 0 で抽出した欠落カテゴリに対し、core docs へ人間理解中心の導線を追加する。
- 新規参加者が「どこから読めばよいか」を短時間で判断できる状態を作る。

## 2. 対象と変更概要

| 対象 | 変更概要 | 効果 |
| --- | --- | --- |
| `AGENTS.md` | ルール中心構成に加えて人間理解導線を明示 | 運用ルールの参照起点が明確化 |
| `README.md` | フレームワーク全体像に導線マップを追加 | 初回オンボーディングの迷いを削減 |
| `docs/INDEX.md` | インデックスの使い方と参照目的を補強 | docs 探索の回遊性を改善 |

## 3. 追加した情報モデル導線

1. 目的
   - なぜこの資料を読むかを各資料冒頭で明示。
2. 使い方
   - どの順で資料を読むかを手順化。
3. 仕組み
   - docs/work/tools の関係を明示。
4. 実装
   - 実行に使う主要ファイル・コマンドへの導線を明示。
5. 関連
   - 関連 docs/task へのリンクを補強。

## 4. Wave 1 operations への引き継ぎ

- core docs で定義した導線粒度を `docs/operations/*` へ展開する。
- runbook/guide/backlog の説明スタイルを同じカテゴリ軸で統一する。
- cross-link 正規化（Wave1 normalize）で docs/work 双方向リンクを最終整備する。

## 5. ロールバック方針

- 可読性低下が発生した場合は、core docs の追加文を最小化し、詳細説明を本資料へ集約する。
- 導線の重複が発生した場合は `docs/INDEX.md` を正本として参照先を一本化する。
