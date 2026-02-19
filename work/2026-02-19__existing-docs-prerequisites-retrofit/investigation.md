# Investigation: 2026-02-19__existing-docs-prerequisites-retrofit

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
  - `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
- 理解ポイント:
  - 既存資料への遡及適用範囲を定量把握し、優先順を定義する。

## 1. 調査対象 [空欄禁止]

- 前提知識セクションの未適用件数と対象領域。
- 優先順での実施に適した分割単位。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- docs/work の既存資料を優先度フェーズで分割して適用すれば、品質リスクを抑えつつ全体導線を改善できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `docs/`
  - `work/`
  - `docs/operations/high-priority-backlog.md`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  - `docs` 配下 markdown の前提知識見出し有無を集計。
  - `work` 配下 markdown の前提知識見出し有無を集計。
  - backlog 現状（planned なし）を確認。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - `docs` は 30 件中 22 件が未適用（archive/legacy 除外）。
  - `work` は 125 件中 110 件が未適用（archive/legacy 除外）。
  - 高優先バックログの `planned` は現時点で空。
- 推測:
  - 一括更新はレビュー負荷が高いため、docs と work をさらに段階化した方が安全。
  - active task 以外の過去 task 文書は後順位に回すと進行管理しやすい。

## 5. 提案オプション [空欄禁止]

1. docs 優先:
   - まず `docs/*` を完了し、その後 `work/*` へ展開する。
2. active-first（推奨）:
   - `docs/operations` + active task を最優先、その後 docs 全体、最後に過去 task 文書へ適用する。
3. batch 一括:
   - docs/work を1タスクで一括更新する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. active-first
- 理由:
  - 運用で頻繁に参照される資料から先行整備できる。
  - 大量差分によるレビュー詰まりを抑制できる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクは「既存資料への前提知識セクション遡及適用」を目的とし、優先度フェーズを仕様へ固定する。
- 実装は次工程とし、本タスクでは要件確定（spec）まで完了する。

## 8. 未解決事項 [空欄禁止]

- なし。

## 9. 次アクション [空欄禁止]

1. `spec.md` に優先度フェーズ、受入条件、テスト要件を確定する。
2. `plan.md` で実装順序と検証順序を定義する。
3. backlog の `planned` 先頭へ登録する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
- spec: `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`
