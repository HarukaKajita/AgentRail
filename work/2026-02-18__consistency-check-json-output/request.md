# Request: 2026-02-18__consistency-check-json-output

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- `check_consistency` の機械可読性を高めるため、JSON出力機能を追加するタスクを起票する。

## 要望の整理

- 現在のテキスト出力に加えて JSON 出力モードを提供する。
- CI や後段ツールが `rule_id`, `file`, `reason` を安定解析できる形式にする。

## 成功条件（要望レベル）

1. `check_consistency` が JSON 形式で結果を出力できる。
2. 既存テキスト出力との互換が維持される。
3. 失敗件数や対象task一覧を JSON に含める。
