# CI ガバナンスと task-id 解決戦略

## 1. タイトル [空欄禁止]

- CI ガバナンスと task-id 解決戦略

## 2. ステータス [空欄禁止]

- Accepted

## 3. 日付 [空欄禁止]

- 2026-02-18

## 4. 背景 (Context / 背景) [空欄禁止]

- `docs-indexer` と `consistency-check` は実装済みだが、CI での運用ルールと task-id 解決ロジックが曖昧だと誤判定のリスクが残る。
- 資料バンクの運用では、決定事項を再利用可能な形で残す必要がある。

## 5. 決定 (Decision / 決定内容) [空欄禁止]

- CI 基盤は GitHub Actions を継続採用する。
- `check_consistency` 対象 task-id は以下の順で決定する。
  1. manual 指定（`workflow_dispatch` 入力）
  2. 差分抽出（`work/<task-id>/`）
  3. 差分 0 件時は `skip` を返して checker 系 step を実行しない
- `workflow_dispatch` で `task_id` が未指定の場合は fail-fast で停止する。
- 差分で複数 task-id が検出された場合は fail-fast で停止する。

## 6. 代替案 (Alternatives / 代替案) [空欄禁止]

- 案A: `work/` の最新更新 1 件を常に採用
- 案B: 全 task を常時走査

## 7. 影響 (Consequences / 影響) [空欄禁止]

- メリット:
  - CI 判定の再現性が向上する
  - 誤った task 検査を減らせる
- デメリット:
  - 複数 task 同時変更時に CI が停止する
- トレードオフ:
  - 開発速度より判定の安全性を優先する

## 8. 関連資料 [空欄禁止]

- spec: `docs/specs/automation-tools-ci-integration-spec.md`
- investigation: `docs/investigations/automation-tools-ci-integration-investigation.md`
- review: `work/2026-02-18__ci-task-resolution-determinism/review.md`
