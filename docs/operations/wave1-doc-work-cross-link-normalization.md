# Wave 1: Doc-Work Cross-Link Normalization

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `docs/operations/wave1-operations-docs-human-centric-migration.md`
  - `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`
- 理解ポイント:
  - 本資料は docs/work 相互リンクの標準ルールと適用結果を定義する。

## 1. 標準ルール

1. docs から work を参照する場合
   - 形式: `` `work/<task-id>/<file>.md` `` を使用する。
2. work から docs を参照する場合
   - 形式: `` `docs/<category>/<file>.md` `` を使用する。
3. セクション配置
   - 相互リンクは `## 9. 関連資料リンク` または `## 関連資料` に集約する。
4. 相対パス統一
   - `./` や OS 依存パス（`\`）を使用しない。

## 2. 適用対象

- `docs/operations/wave1-core-docs-human-centric-migration.md`
- `docs/operations/wave1-operations-docs-human-centric-migration.md`
- `docs/operations/high-priority-backlog.md`

## 3. 適用内容

1. wave1 migration docs に `関連 task` セクションを追加し、`work/<task-id>/spec.md` / `review.md` を明示した。
2. docs 側参照は `docs/operations/*.md` の backtick path に統一した。
3. backlog からの参照導線は `spec.md` 基準で統一し、depends_on 判定に必要な path を固定した。

## 4. 効果

- docs から task 成果物へ遡る手順が一定化。
- consistency/state-validate でのリンク検証が安定。
- Wave 2 以降の docs 品質チェック仕様へ接続しやすくなった。

## 5. 次工程への引き継ぎ

- `2026-02-20__wave2-spec-doc-quality-check-rules` で cross-link ルールを品質チェック仕様へ取り込む。
