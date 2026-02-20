# Investigation: 2026-02-18__consistency-check-json-schema-version-policy

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- `tools/consistency-check/check.ps1` の JSON 出力におけるスキーマバージョン管理方式。

## 2. 仮説 (Hypothesis) (必須)

- JSON 出力のトップレベルに `schema_version` を明示し、互換ポリシーを docs に定義すれば、将来拡張時の破壊的変更判定が容易になる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `tools/consistency-check/check.ps1`
  - `docs/specs/automation-tools-design-spec.md`
  - `work/2026-02-18__consistency-check-json-output/review.md`
- 実施した確認:
  - `-OutputFormat json` の single/multi 両モード出力形式を確認
  - 既存仕様で `schema_version` が未定義であることを確認
  - docs 側に「次タスク検討事項」として未決事項が残っていることを確認

## 4. 調査・観測結果 (Observations) (必須)

- 現行 JSON は task_id / status / failure_count / failures（single）または mode / task_count / results（multi）を返すが、スキーマ版を識別するキーがない。
- そのため、将来 `results` 配下やトップレベル項目を変更した際に、利用側が互換判定を自動化しにくい。
- `docs/specs/automation-tools-design-spec.md` に schema version 導入可否が未確定事項として残っている。

## 5. 結論 (Conclusion) (必須)

- `tools/consistency-check/check.ps1` に JSON スキーマバージョン定数を追加し、single/multi どちらの JSON 出力にも `schema_version` を付与する。
- 互換ポリシーを docs に追記し、「互換追加は minor、破壊変更は major」を運用ルールとして明文化する。

## 6. 未解決事項 (Open Issues) (必須)

- 初期バージョン番号を `1.0.0` とし、patch の利用方針を運用上どう扱うか（今回は policy に定義する）。

## 7. 次のアクション (Next Action) (必須)

1. `spec.md` の受入条件とテスト要件を `schema_version` 導入内容で具体化する。
2. `plan.md` に single/multi 両モードの検証コマンドを追加する。
3. `tools/consistency-check/check.ps1` と関連 docs を更新して回帰確認を行う。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__consistency-check-json-schema-version-policy/request.md`
- spec: `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`
