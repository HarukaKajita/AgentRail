# Wave 1 Operations Docs: Human-Centric Migration

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`
- 理解ポイント:
  - 本資料は operations docs 補完の変更内容と残課題をまとめた記録である。

## 1. 目的

- Wave 0 で抽出した operations docs の欠落カテゴリを補完する。
- Wave 1 normalize task が cross-link 正規化に集中できる状態を作る。

## 2. 対象資料

- `docs/operations/ci-failure-runbook.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `docs/operations/runtime-framework-rules.md`
- `docs/operations/high-priority-backlog.md`

## 3. 実施内容

1. `ci-failure-runbook.md`
   - 復旧手順の前に「目的/使い方/仕組み/実装/関連」観点の参照ガイドを追加。
2. `framework-request-to-commit-visual-guide.md`
   - フロー図の前提として読者別の参照順を追加。
3. `runtime-framework-rules.md`
   - ルール参照時の実務導線と関連資料関係を補強。
4. `high-priority-backlog.md`
   - 優先タスクの読み方と依存判定の参照観点を補強。

## 4. 補完後の残課題

- docs と work の相互リンク表記はまだ揺れがある。
- 資料間でリンクの粒度（ファイル単位/セクション単位）が混在している。
- 上記は `2026-02-20__wave1-normalize-doc-work-cross-links` で解消する。

## 5. ロールバック方針

- 追記により可読性が低下した場合は、導線説明を簡略化し詳細を本資料に集約する。
- 関連リンクの整合崩れがあれば `docs/INDEX.md` と `high-priority-backlog.md` を先に復旧する。

## 6. 関連 task

- `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`
- `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/review.md`
- `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`
