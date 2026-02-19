# Investigation: 2026-02-18__ci-task-resolution-determinism

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- CI 上で `check_consistency` 対象 task-id を安定的に解決する方式。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 変更差分（`git diff` 対象）から `work/<task-id>/` を抽出すれば、最新時刻依存よりも決定性が高い。
- 差分から一意に定まらないケースを即失敗にすれば誤検査を防げる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  - 現在は latest 1件方式で解決している
  - 同時更新や無関係更新に弱い

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 現在の `LastWriteTime` 方式は、変更内容との因果が弱い。
- CI イベント種別ごとに差分取得手順を分ける必要がある。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- 変更差分優先 + 明示フォールバックの2段方式を採用する。
- 解決不能時は失敗し、手動指定（workflow_dispatch input）を補助経路として用意する。

## 6. 未解決事項 [空欄禁止]

- push イベントにおける `before` SHA が使えないケースの扱い。

## 7. 次アクション [空欄禁止]

1. task-id 解決ロジック仕様を確定する。
2. workflow への統合差分を設計する。
3. 異常系シナリオをテストケース化する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__ci-task-resolution-determinism/request.md`
- spec: `work/2026-02-18__ci-task-resolution-determinism/spec.md`
