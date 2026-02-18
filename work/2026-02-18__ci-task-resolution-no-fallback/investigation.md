# Investigation: 2026-02-18__ci-task-resolution-no-fallback

## 1. 調査対象 [空欄禁止]

- `tools/ci/resolve-task-id.ps1` の fallback ロジックと CI 側の実行条件。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- fallback を廃止し、差分0件では checker 系を skip すれば無関係 FAIL を防げる。
- `workflow_dispatch` の `task_id` を必須化すれば実行意図が明確になる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `.github/workflows/ci-framework.yml`
  - `tools/ci/resolve-task-id.ps1`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  - 現状は差分0件時に fallback で `work/` 降順先頭 task を採用している。
  - workflow は常に checker 系を実行している。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 差分に無関係な planned task が選ばれる可能性がある。
- planned task の未実装参照により CI が失敗することがある。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- task-id 解決結果に `skip` 状態を導入し、workflow 側で条件分岐する。
- `workflow_dispatch` で `task_id` 未指定は失敗させる。

## 6. 未解決事項 [空欄禁止]

- `skip` をジョブ成功扱いにする際のログフォーマット。

## 7. 次アクション [空欄禁止]

1. resolve script の I/O を拡張する。
2. workflow の step 条件を追加する。
3. docs/ADR を実装完了後に同期更新する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__ci-task-resolution-no-fallback/request.md`
- spec: `work/2026-02-18__ci-task-resolution-no-fallback/spec.md`
