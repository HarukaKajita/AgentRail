# Investigation: 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `.github/workflows/ci-framework.yml`
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/request.md`
- 理解ポイント:
  - runbook の手順は CI 実装の step 順序と一致している必要がある。

## 1. 調査対象 [空欄禁止]

- 課題: fail mode 導入後の CI 実装と運用 docs の乖離を解消する。
- 目的: 失敗時の切り分け手順を warning/fail 二段ゲートへ整合させる。
- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- runbook と実装ガイドに `DocQualityMode` の役割と実行順序を明示すれば、復旧時間を短縮できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `.github/workflows/ci-framework.yml`
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
- 実施した確認:
  1. CI step の実行順序とモード指定（warning/fail）を抽出した。
  2. runbook の失敗パターンが step 名と一致しているか比較した。
  3. 実装ガイドに state-validate の運用が反映されているか確認した。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - CI は `-AllTasks -DocQualityMode warning` と `-TaskId -DocQualityMode fail` の二段構成で実行される。
  - 既存 runbook では fail mode step（target task の state-validate/consistency-check）が明示されていなかった。
  - 実装ガイドのチェックリストも consistency-check 中心で、state-validate 併用が弱かった。
- 推測:
  - step 名と対応コマンドを runbook へ追加すれば、運用者の再現精度が向上する。

## 5. 提案オプション [空欄禁止]

1. runbook のみ更新
2. runbook + 実装ガイドを同時更新（推奨）
3. docs 更新を Wave 3 へ延期

## 6. 推奨案 [空欄禁止]

- 推奨: 2. runbook + 実装ガイドを同時更新
- 理由:
  - 運用手順と実装手順の差分を同時に埋められるため。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- `ci-failure-runbook` と `framework-request-to-commit-visual-guide` を fail/warning 二段ゲートに同期する。

## 8. 未解決事項 [空欄禁止]

- warning 21 件の優先解消順（Wave 3 KPI タスクで管理）。

## 9. 次アクション [空欄禁止]

1. runbook を CI step 順序に合わせて再構成する。
2. 実装ガイドのチェックリストを state-validate 含めて更新する。
3. backlog/state/MEMORY を Wave 3 着手前へ同期する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/request.md`
- spec: `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
- docs:
  - `docs/operations/ci-failure-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
