# Investigation: 2026-02-18__consistency-check-json-output

## 1. 調査対象 [空欄禁止]

- `tools/consistency-check/check.ps1` の結果を機械可読化する出力仕様。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `-OutputFormat text|json` を導入すれば既存互換を維持しつつ拡張できる。
- JSON へ run metadata と failures を含めれば CI 集計に十分使える。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/phase2-automation-spec.md`
- 実施した確認:
  - 現在はテキストのみ
  - CI の失敗詳細はログ依存

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- テキストログは人間には読めるが機械集計しにくい。
- JSON 追加だけでも、通知・集計・可視化の拡張余地が大きい。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `-OutputFormat json` を追加し、標準出力または `-OutputFile` へ保存できるようにする。
- JSON スキーマを docs に明記する。

## 6. 未解決事項 [空欄禁止]

- JSON 出力時に text ログを併記するかどうか。

## 7. 次アクション [空欄禁止]

1. JSON スキーマを定義する。
2. output パラメータ仕様を確定する。
3. CI 連携仕様の反映範囲を決定する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__consistency-check-json-output/request.md`
- spec: `work/2026-02-18__consistency-check-json-output/spec.md`
