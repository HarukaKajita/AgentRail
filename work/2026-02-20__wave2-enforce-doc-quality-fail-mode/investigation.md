# Investigation: 2026-02-20__wave2-enforce-doc-quality-fail-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/request.md`
  - `.github/workflows/ci-framework.yml`
- 理解ポイント:
  - fail 強制は運用経路で有効化し、全体回帰は warning 経路を維持して段階移行する。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: warning 観測結果を踏まえ、docs品質 issue を fail 判定へ昇格する。
- 目的: CI での適用ポイント・rollback 方針・回帰影響を明確化する。
- 依存: `2026-02-20__wave2-implement-doc-quality-warning-mode`

## 2. 仮説 (Hypothesis) (必須)

- state-validate と consistency-check の対象 task 実行に fail mode を明示指定すれば、段階導入を維持しつつ fail 強制を開始できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `.github/workflows/ci-framework.yml`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
  - `docs/operations/high-priority-backlog.md`
- 実施した確認:
  1. warning mode (`-AllTasks`) の warning 件数と分布を確認した。
  2. fail mode (`-TaskId`) が warning issue を exit code 1 に変換することを確認した。
  3. CI の実行順序（resolve task -> consistency-check）へ fail mode を挿入可能か確認した。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - warning mode 全体実行では warning 21 件が残るため、`-AllTasks` へ即時 fail 適用すると CI が不安定化する。
  - `DocQualityMode=fail` を指定した task 単位実行では docs品質 issue が FAIL になることを確認した。
  - 変更対象 task 経路へ fail mode を適用する実装は既存 CI フローに追加可能。
- 推測:
  - `-AllTasks` は warning 維持、`resolved_task_id` 経路は fail 強制とする二段構成が現時点の最適解。

## 5. 提案オプション (必須)

1. 全経路 fail 即時適用
2. CI の対象 task 経路のみ fail 強制（推奨）
3. fail 適用は後続タスクへ延期

## 6. 推奨案 (必須)

- 推奨: 2. CI の対象 task 経路のみ fail 強制
- 理由:
  - warning 21 件を抱えたままでも運用移行を進められ、ブロッカー化を回避できるため。

## 7. 結論 (Conclusion / 結論) (必須)

- CI の変更対象 task に `DocQualityMode=fail` を適用し、docs品質 issue の fail 昇格を開始する。

## 8. 未解決事項 (必須)

- warning 21 件の解消優先順（後続 `wave2-align` と Wave 3 KPI で管理）。

## 9. 次アクション (必須)

1. CI workflow を fail 強制フローへ更新する。
2. fail mode 運用ドキュメントを追加する。
3. `wave2-align-ci-runbook-with-doc-quality-gates` を plan-ready へ更新する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/request.md`
- spec: `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
- docs: `docs/operations/wave2-doc-quality-fail-mode.md`
