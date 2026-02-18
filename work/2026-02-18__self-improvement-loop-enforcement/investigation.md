# Investigation: 2026-02-18__self-improvement-loop-enforcement

## 1. 調査対象 [空欄禁止]

- 漏れ再発が起きた要因と、既存CI/checkerでの検知可能範囲。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `review.md` の改善知見が機械判定対象でないことが主因。
- 重大 finding の task 接続を強制すれば再発率を下げられる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `開発ワークフローと自動化.md`
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
- 実施した確認:
  - 現行チェックは spec/index/profile 中心
  - review の改善提案は fail 条件に含まれていない

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- フロー上は「気づきを資料へ反映」が要求されるが、パイプラインで強制されていない。
- 重大改善の未起票が発生しても、既存ルールでは検知できない。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- Process Findings スキーマ + CI強制 + 起票補助CLI を導入する。
- 強制閾値は must-high とし、`linked_task_id` 実在確認まで行う。

## 6. 未解決事項 [空欄禁止]

- 将来的に `medium` を強制対象へ拡張するか。

## 7. 次アクション [空欄禁止]

1. 自己改善ループ仕様を docs へ追加する。
2. scan/create-task/checker/CI を実装する。
3. ランブックとテンプレートを更新する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__self-improvement-loop-enforcement/request.md`
- spec: `work/2026-02-18__self-improvement-loop-enforcement/spec.md`
