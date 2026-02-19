# Request: 2026-02-18__automation-tools-ci-integration

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- CI 連携タスク（自動化基盤段階）を起票して `index_docs` / `check_consistency` をパイプラインに組み込む。

## 要望の整理

- GitHub Actions を導入し、push/pull_request で自動検証する。
- `docs-indexer` 実行後に `docs/INDEX.md` 差分があれば失敗させる。
- `work/` の最新 task-id を自動解決して `check_consistency` を実行する。

## 成功条件（要望レベル）

1. `.github/workflows/ci-framework.yml` が追加される。
2. CI が `docs-indexer` と `check_consistency` を実行する。
3. 最新 task-id が自動解決される。
4. CI連携に関する仕様/調査記録が docs に反映される。
