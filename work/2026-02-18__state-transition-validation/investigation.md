# Investigation: 2026-02-18__state-transition-validation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- `work/<task-id>/state.json` の状態遷移整合を機械検証する方式。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 許可状態セットと遷移表を定義すれば不正遷移を検知できる。
- `done` 条件に成果物整合チェックを追加すると運用品質が上がる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `work/*/state.json`
  - `.github/workflows/ci-framework.yml`
- 実施した確認:
  - state 必須キーは定義済み
  - 遷移の機械検証は未実装

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 現在は state 値の妥当性を自動確認していない。
- 人手更新の揺れを検知するには validator が必要。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `tools/state-validate/validate.ps1` を追加する。
- 単一 task と全 task の両モードを将来考慮して設計する。

## 6. 未解決事項 [空欄禁止]

- 遷移履歴を保存しない現状で「遷移」そのものをどこまで厳密に判定するか。

## 7. 次アクション [空欄禁止]

1. 許可状態と整合条件を定義する。
2. validator I/O を確定する。
3. CI の実行タイミングを決める。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__state-transition-validation/request.md`
- spec: `work/2026-02-18__state-transition-validation/spec.md`
