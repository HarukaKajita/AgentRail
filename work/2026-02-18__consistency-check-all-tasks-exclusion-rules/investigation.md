# Investigation: 2026-02-18__consistency-check-all-tasks-exclusion-rules

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- `tools/consistency-check/check.ps1` の `-AllTasks` 走査時における archive/legacy ディレクトリ除外ルール。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `-AllTasks` で archive/legacy 系ディレクトリを除外すれば、保守対象外 task のノイズを減らしつつ、現行 task の fail-fast は維持できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `work/2026-02-18__consistency-check-multi-task-mode/review.md`
  - `work/2026-02-18__consistency-check-multi-task-mode/spec.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  - source task review の Process Findings を確認
  - `-AllTasks` 実装が現状は `work/` 直下を無条件で全ディレクトリ走査していることを確認
  - 既存仕様で archive/legacy の除外条件が未定義なことを確認

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- source task の finding では、`-AllTasks` が legacy task の不整合を拾い、運用上のノイズになる点が指摘されている。
- 現行 `tools/consistency-check/check.ps1` の all モードは `work/` 直下ディレクトリをすべて対象化し、名前による除外判定を持たない。
- `docs/specs/automation-tools-design-spec.md` にも `-AllTasks` 除外条件が未確定事項として残っている。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `-AllTasks` 時に「ディレクトリ名が `archive`/`legacy` で始まるもの」を除外するルールを採用する。
- ただし `-TaskId` / `-TaskIds` は従来どおり明示指定を優先し、除外ルールを適用しない。
- 仕様 docs に除外基準を追記し、運用側へ明示する。

## 6. 未解決事項 [空欄禁止]

- archive/legacy 以外の将来除外カテゴリ（`disabled` など）を一般化するかどうかは別タスクとする。

## 7. 次アクション [空欄禁止]

1. `spec.md` に除外ルールの正規表現と受入条件を明記する。
2. `plan.md` に temp work root を使った PASS/FAIL 検証コマンドを定義する。
3. `tools/consistency-check/check.ps1` と docs を更新し、回帰確認する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/request.md`
- spec: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`
