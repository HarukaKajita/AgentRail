# Investigation: 2026-02-18__consistency-check-multi-task-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- `tools/consistency-check/check.ps1` の複数 task 検査モード追加方式。

## 2. 仮説 (Hypothesis) (必須)

- `-TaskId` を維持しつつ `-TaskIds` / `-AllTasks` を追加すれば後方互換を保てる。
- 検査結果を task 単位で集約すれば運用の可観測性が上がる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/automation-tools-design-spec.md`
- 実施した確認:
  - 現在は `-TaskId` 必須で単一対象のみ
  - CI では latest 1件方式のため過去 task の崩れを見逃す可能性あり

## 4. 調査・観測結果 (Observations) (必須)

- 単一対象前提のままでは、定期的な全体整合チェックが難しい。
- 実行対象の指定方式を増やすと運用柔軟性が上がる。

## 5. 結論 (Conclusion) (必須)

- parameter set を分けて `-TaskId` / `-TaskIds` / `-AllTasks` を実装する。
- 終了コードは「1件でもFAILなら1」を維持する。

## 6. 未解決事項 (Open Issues) (必須)

- `-AllTasks` 実行時に除外する task（archived など）の扱い。

## 7. 次のアクション (Next Action) (必須)

1. パラメータ仕様を確定する。
2. task 単位集計の出力仕様を定義する。
3. CI 連携時の利用方式を決める。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__consistency-check-multi-task-mode/request.md`
- spec: `work/2026-02-18__consistency-check-multi-task-mode/spec.md`
