# Investigation: 2026-02-20__fix-wave3-investigation-broken-tmp-reference

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `tools/consistency-check/check.ps1`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/request.md`
- 理解ポイント:
  - 実ファイルの存在を前提にするローカル参照は、起票資料では環境依存で壊れやすい。

## 1. 調査対象 [空欄禁止]

- 課題: task12 investigation の記述が `link_targets_exist` を FAIL にしている。
- 目的: 参照切れ原因の確定と、再発防止の記述ルール策定。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 一時ファイルを資料の参照資料欄へ直接書かない方針に統一すれば再発を防止できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
- 実施した確認:
  1. FAIL を再現し、対象ファイルと rule_id を特定する。
  2. 一時出力パス参照の記述箇所を抽出する。
  3. 代替記述（コマンド記載/恒久パス参照）の選択肢を比較する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - `link_targets_exist` の FAIL は task12 investigation の一時出力パス記述で再現する。
  - `.tmp` を削除した運用でも、他タスクは同 rule で FAIL していない。
- 推測:
  - 参照資料欄へ一時パスを書かないルールを追記すれば再発率を低下できる。

## 5. 提案オプション [空欄禁止]

1. task12 のみ修正する。
2. task12 修正 + 再発防止ルールを docs へ追記する（推奨）。
3. checker 側で一時パス参照を無視する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 修正 + ルール追記
- 理由:
  - checker 仕様を変えずに運用品質を上げられる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- task12 investigation の該当記述を恒久参照へ置換し、起票資料の記述ルールを補足する。

## 8. 未解決事項 [空欄禁止]

- 同種記述が過去 task に残存しているかの横断確認範囲。

## 9. 次アクション [空欄禁止]

1. spec で修正対象と受入条件を確定する。
2. plan-draft で検証手順を固定する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/request.md`
- spec: `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`
