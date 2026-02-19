# Investigation: 2026-02-19__ci-profile-schema-version-governance-gate

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 1. 調査対象 [空欄禁止]

- `schema_version`（2.x 以降）更新ルールを CI で強制する設計方針。
- 既存 CI（`ci-framework.yml`）へ追加する最小変更点と運用 docs の更新範囲。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- profile schema 変更時の versioning 判定を専用スクリプトで機械化し、CI で実行すれば、`schema_version` 更新漏れと不整合を確実に防止できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `.github/workflows/ci-framework.yml`
  - `tools/profile-validate/profile-schema.json`
  - `tools/profile-validate/validate.ps1`
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `project.profile.yaml`
- 実施した確認:
  - 現行 CI は profile validator を実行するが、base/head 差分に基づく schema version 更新ルール判定は未実装。
  - `tools/profile-validate/profile-schema.json` は `schema_version` / `supported_profile_schema_versions` / `forbidden_top_level_keys` を保持する。
  - policy docs は更新ルールを文章で示しているが、CI 強制が未定義。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - CI は `docs-indexer -> profile-validate -> state-validate -> resolve-task -> consistency-check` の順で動作している。
  - `profile-validate` 自体は「現在値の妥当性」は検証できるが、「更新時に version を上げたか」は検証できない。
  - `tools/profile-validate/profile-schema.json` の変更有無を base/head で比較する仕組みは未実装。
- 推測:
  - schema version ガード専用 step を CI の「Validate project profile」前に追加すると、失敗原因を切り分けやすい。
  - 変更種別ごとの判定ルールを先に spec で固定しないと実装時の解釈差が出る。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- CI で schema version 更新運用を強制する新規 task を起票し、実装前に判定ルールを spec で確定する。
- 実装対象は以下を想定する:
  1. profile schema governance 用の新規 PowerShell script
  2. `.github/workflows/ci-framework.yml` への governance step 追加
  3. policy / CI spec / runbook の docs 更新
- `supported_profile_schema_versions` への追加のみは非破壊変更として扱い、major 増分必須ルールの対象外とする。

## 6. 未解決事項 [空欄禁止]

- なし。

## 7. 次アクション [空欄禁止]

1. `spec.md` で AC とテスト要件を 1:1 対応で確定する。
2. breaking/non-breaking の判定ルールを具体化する。
3. backlog へ `planned` 登録し、実装着手順を固定する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
- spec: `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`

