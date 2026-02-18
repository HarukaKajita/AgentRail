# Investigation: 2026-02-18__docs-indexer-check-mode

## 1. 調査対象 [空欄禁止]

- `docs-indexer` の非破壊検証モード追加方式。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `apply` と `check` のモード分岐を追加すれば、ローカル更新用途とCI検証用途を両立できる。
- 差分判定はメモリ上の再生成結果と現行 `docs/INDEX.md` を比較すれば実現できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `tools/docs-indexer/index.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/phase2-ci-integration-spec.md`
- 実施した確認:
  - 現状は常に `docs/INDEX.md` を上書き
  - CI は `git diff --exit-code` に依存

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 現行実装は副作用（書き込み）前提で、CI向けには過剰操作が含まれる。
- `check` モードを追加すれば、CIの安全性と意図明確性が向上する。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `-Mode apply|check` を導入し、既定を `apply` にする。
- `check` モードでは書き込みせず、差分有無のみを返す。

## 6. 未解決事項 [空欄禁止]

- 差分サマリを `check` モードでどこまで詳細表示するか。

## 7. 次アクション [空欄禁止]

1. モード仕様を `spec.md` に確定する。
2. CI 呼び出しを `check` モードへ切り替える。
3. docs を更新して INDEX へ反映する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__docs-indexer-check-mode/request.md`
- spec: `work/2026-02-18__docs-indexer-check-mode/spec.md`
