# Investigation: 2026-02-18__state-transition-validation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- `work/<task-id>/state.json` の状態遷移整合を機械検証する方式。

## 2. 仮説 (Hypothesis) (必須)

- 許可状態セットと遷移表を定義すれば不正遷移を検知できる。
- `done` 条件に成果物整合チェックを追加すると運用品質が上がる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `AGENTS.md`
  - `work/*/state.json`
  - `.github/workflows/ci-framework.yml`
- 実施した確認:
  - state 必須キーは定義済み
  - 遷移の機械検証は未実装

## 4. 調査・観測結果 (Observations) (必須)

- 現在は state 値の妥当性を自動確認していない。
- 人手更新の揺れを検知するには validator が必要。

## 5. 結論 (Conclusion) (必須)

- `tools/state-validate/validate.ps1` を追加する。
- 単一 task と全 task の両モードを将来考慮して設計する。

## 6. 未解決事項 (Open Issues) (必須)

- 遷移履歴を保存しない現状で「遷移」そのものをどこまで厳密に判定するか。

## 7. 次のアクション (Next Action) (必須)

1. 許可状態と整合条件を定義する。
2. validator I/O を確定する。
3. CI の実行タイミングを決める。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__state-transition-validation/request.md`
- spec: `work/2026-02-18__state-transition-validation/spec.md`
