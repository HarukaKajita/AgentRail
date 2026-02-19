# Investigation: 2026-02-19__profile-validator-required-checks-source-of-truth

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- Source task 2026-02-18__project-profile-schema-validation の finding F-001 の根本原因分析。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `requiredChecks` をスクリプト内の静的配列から切り離し、専用 schema 定義へ移せば、profile 拡張時の更新漏れリスクを下げられる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - work/2026-02-18__project-profile-schema-validation/review.md
  - tools/profile-validate/validate.ps1
  - docs/operations/validator-enhancement-backlog.md
- 実施した確認:
  - finding の evidence にある `requiredChecks` 静的配列が現行コードに存在するかを確認する。
  - required key 定義の保守点がどこに分散しているかを確認する。
  - validator の挙動を変えずに source of truth 化できる実装方式を確認する。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- `tools/profile-validate/validate.ps1` に `requiredChecks` 配列があり、required path と regex が直接ハードコードされている。
- 必須キーの追加・変更時に、`tools/profile-validate/validate.ps1` の配列修正を忘れると validator が実態と乖離するリスクがある。
- 現行 validator は regex ベースで判定しており、path 情報から regex を機械生成する方式に置き換えても互換を維持できる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `tools/profile-validate/profile-schema.json` を追加し、required key path と value_type（scalar/container）を定義する。
- `tools/profile-validate/validate.ps1` は schema 定義を読み込んで検証ループを実行し、required path の単一ソースを schema ファイルに集約する。
- docs に schema ファイルを更新起点として明記し、運用時の変更手順を固定する。

## 6. 未解決事項 [空欄禁止]

- `consistency-check` 側の profile 必須キー検証との統合方針（本タスクは validator 側の source of truth 化に限定）。

## 7. 次アクション [空欄禁止]

1. schema 定義ファイルを追加し、validator の required checks を動的読み込みへ置換する。
2. validator 実行結果（PASS/FAIL）を既存期待に合わせて確認する。
3. docs / review / state を更新し、consistency-check で完了条件を確認する。

## 8. 関連リンク [空欄禁止]

- request: work/2026-02-19__profile-validator-required-checks-source-of-truth/request.md
- spec: work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md
- source review: work/2026-02-18__project-profile-schema-validation/review.md
