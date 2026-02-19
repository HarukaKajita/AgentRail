# Investigation: 2026-02-19__task-doc-prerequisite-knowledge-section

## 1. 調査対象 [空欄禁止]

- task 成果物（request/investigation/spec/plan/review）の現行フォーマットに、前提知識セクションが存在するか。
- 既存テンプレートと起票生成スクリプトで前提知識を自動付与できるか。
- 整合チェックで前提知識セクションを強制する拡張余地。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 前提知識セクションの書式を標準化し、起票時の自動生成と整合チェックを組み合わせれば、どの資料からでも遡及可能な理解導線を運用で維持できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `docs/templates/spec.md`
  - `docs/templates/investigation.md`
  - `docs/templates/review.md`
  - `tools/improvement-harvest/create-task.ps1`
  - `tools/consistency-check/check.ps1`
  - `docs/operations/high-priority-backlog.md`
- 実施した確認:
  - templates には前提知識専用セクションが未定義であることを確認。
  - `tools/improvement-harvest/create-task.ps1` の生成文面に前提知識セクションが未定義であることを確認。
  - `tools/consistency-check/check.ps1` は必須ファイルや空欄禁止を検査するが、前提知識セクションの存在は検査していないことを確認。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - spec/investigation/review テンプレートに前提知識セクションがない。
  - request/plan はテンプレートファイルがなく、起票・運用文面ベースで管理されている。
  - consistency-check に前提知識に関する検証ルールがない。
- 推測:
  - 現状運用では、資料間の読み順を暗黙知で補っており、文書の単独可読性にばらつきが出る。

## 5. 提案オプション（3案） [空欄禁止]

1. 最小変更:
   - spec テンプレートにのみ前提知識を追加し、他資料は任意運用とする。
2. バランス:
   - task 5資料に前提知識セクションを導入し、今後作成分のみ必須化する。
3. 強化（採用）:
   - task 5資料と仕様資料の前提知識フォーマットを統一し、起票生成・checker・遡及更新方針を仕様に含める。

## 6. 推奨案 [空欄禁止]

- 採用: オプション3（強化）
- 理由:
  - 要望のゴールが「どこから読んでも遡れる状態」であり、任意運用では再現性が不足するため。
  - 起票と検証を同時に仕様化することで、継続運用の確実性が高まるため。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクの仕様は、前提知識セクションの標準項目、記法、運用強制（checker）、既存資料への適用範囲を一体で定義する。
- 段階導入ではなく、少なくとも active な task/docs 群では即時適用を目標とする。

## 8. 未解決事項 [空欄禁止]

- なし（対象範囲は active な docs/work 運用領域に定義する）。

## 9. 次アクション [空欄禁止]

1. `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md` で AC とテスト要件を確定する。
2. `work/2026-02-19__task-doc-prerequisite-knowledge-section/plan.md` で実装順序と検証順序を定義する。
3. backlog と memory に起票状態を反映する。

## 10. 確認質問（2〜4件） [空欄禁止]

- なし（今回の起票では未確定点なしで進行可能）。

## 11. blocked 判定 [空欄禁止]

- blocked ではない。

## 12. 関連リンク [空欄禁止]

- request: `work/2026-02-19__task-doc-prerequisite-knowledge-section/request.md`
- spec: `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
