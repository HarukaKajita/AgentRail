# Investigation: 2026-02-18__framework-pilot-01

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- 手動運用開始直後の運用開始可否と、厳格ブロックを満たすための不足項目。

## 2. 仮説 (Hypothesis) (必須)

- `project.profile.yaml` の `TODO_SET_ME` が主ブロッカーであり、これを解消すれば運用開始できる。
- 実タスク成果物が 1 件もないため、`work/` と `docs/` の連携が検証できていない。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `project.profile.yaml`
- 実施した確認:
  - リポジトリ内ファイル一覧
  - 厳格ブロック条件との照合
  - テンプレート必須項目の確認

## 4. 調査・観測結果 (Observations) (必須)

- `project.profile.yaml` の build/test/format/lint と paths が未設定。
- `docs/INDEX.md` は運用資料とテンプレートのみ登録済みで、spec/investigation 登録が未実施。
- `work/` に実タスクが存在せず、state 遷移の実例が無い。

## 5. 結論 (Conclusion) (必須)

- 運用開始の最短経路は、profile 実値化とパイロットタスク 1 件の完遂。
- 同時に docs 昇格と INDEX 更新を行うことで、SSOT 運用の成立性を実証できる。

## 6. 未解決事項 (Open Issues) (必須)

- 自動化基盤（indexer/checker）の実装言語は未決定。
- CI 連携タイミングは未決定。

## 7. 次のアクション (Next Action) (必須)

1. `project.profile.yaml` を実行可能値へ更新する。
2. パイロットタスク成果物を `work/2026-02-18__framework-pilot-01/` に作成する。
3. docs へ昇格し `docs/INDEX.md` を更新する。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__framework-pilot-01/request.md`
- spec: `work/2026-02-18__framework-pilot-01/spec.md`
