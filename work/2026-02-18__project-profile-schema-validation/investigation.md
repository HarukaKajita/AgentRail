# Investigation: 2026-02-18__project-profile-schema-validation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- `project.profile.yaml` の機械検証方式。

## 2. 仮説 (Hypothesis) (必須)

- PowerShell で YAML パース + キー検証を行えば依存を増やさず実装できる。
- profile 専用 validator を分離すると保守しやすい。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `project.profile.yaml`
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
- 実施した確認:
  - 現在は checker 内に一部パターン検証のみ
  - profile 単体の検証責務が独立していない

## 4. 調査・観測結果 (Observations) (必須)

- スキーマ不整合が checker 実行時まで遅延する。
- profile 専用 validator 追加で失敗原因を明確化できる。

## 5. 結論 (Conclusion) (必須)

- `tools/profile-validate/validate.ps1` を追加する。
- CI step で checker 前に実行する。

## 6. 未解決事項 (Open Issues) (必須)

- YAML パーサ依存をどう扱うか（純正実装/モジュール利用）。

## 7. 次のアクション (Next Action) (必須)

1. スキーマ項目を確定する。
2. validator 入出力仕様を作る。
3. CI 組み込み順序を決める。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__project-profile-schema-validation/request.md`
- spec: `work/2026-02-18__project-profile-schema-validation/spec.md`
