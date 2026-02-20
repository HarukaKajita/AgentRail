# Investigation: 2026-02-20__wave2-implement-doc-quality-warning-mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/request.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 理解ポイント:
  - warning 段階ではルール違反を観測値として出力し、終了コードへ影響させない。

## 1. 調査対象 [空欄禁止]

- 課題: DQ-001〜DQ-004 を warning として可視化する実装方式の確定。
- 目的: fail 昇格前に warnings を継続観測できる実装を導入する。
- 依存: `2026-02-20__wave2-spec-doc-quality-check-rules`

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `DocQualityMode` を `off|warning|fail` の共通スイッチで両 validator に導入すれば、段階導入と昇格の両方を同一手順で扱える。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `docs/operations/high-priority-backlog.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 実施した確認:
  1. 現行 validator のパラメータ・終了コード・出力形式を確認した。
  2. docs 関連の既存検証（前提知識/INDEX/depends_on）と DQ-001〜DQ-004 の対応関係を整理した。
  3. `-AllTasks` 実行で warning 観測件数を取得し、既存 PASS を維持できることを確認した。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 既存実装は docs 品質観点を FAIL 判定に直接組み込む箇所と未実装箇所が混在していた。
  - `DocQualityMode=warning` 実装後、`consistency-check -AllTasks` / `state-validate -AllTasks` は PASS を維持した。
  - warning 集計は全体で 21 件を観測した（主に DQ-002: docs/work 双方向参照不足）。
- 推測:
  - fail 昇格時は観測済み warning を優先的に解消し、CI fail へ切替えても回帰を抑制できる。

## 5. 提案オプション [空欄禁止]

1. `consistency-check` のみ対応
2. 両 validator を同時対応（推奨）
3. 先に CI fail へ昇格

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 両 validator を同時対応
- 理由:
  - ルール適用範囲を揃えた上で warning 観測を開始でき、後続タスクの切替コストを下げられるため。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- `DocQualityMode` を `consistency-check` / `state-validate` に追加し、warning mode を既定として導入する。

## 8. 未解決事項 [空欄禁止]

- fail モード昇格時に警告 21 件をどう扱うかの閾値設計（後続 `wave2-enforce` で確定）。

## 9. 次アクション [空欄禁止]

1. 実装差分を docs に反映し warning mode 運用ガイドを作成する。
2. `wave2-enforce-doc-quality-fail-mode` を plan-ready へ更新する。
3. fail 昇格前の解消対象 warning を backlog 管理へ接続する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/request.md`
- spec: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`
- docs: `docs/operations/wave2-doc-quality-warning-mode.md`
