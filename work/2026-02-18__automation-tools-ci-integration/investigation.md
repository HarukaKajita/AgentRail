# Investigation: 2026-02-18__automation-tools-ci-integration

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- 自動化基盤段階の CI 統合として `docs-indexer` / `consistency-check` を CI へ組み込む方式。

## 2. 仮説 (Hypothesis) (必須)

- GitHub Actions で PowerShell スクリプトをそのまま実行できる。
- `work/` 最新ディレクトリを選べば、毎回対象 task-id を明示入力せずに運用できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `docs/specs/automation-tools-design-spec.md`
  - `project.profile.yaml`
  - `tools/docs-indexer/index.ps1`
  - `tools/consistency-check/check.ps1`
- 実施した確認:
  - `.github/workflows/` 未存在を確認
  - CI 基盤の候補を比較し GitHub Actions を採用
  - task-id 解決方式（最新 task 自動検出）を確定

## 4. 調査・観測結果 (Observations) (必須)

- リポジトリに CI 定義が存在せず、現状はローカル運用のみ。
- `check_consistency` は `-TaskId` 必須のため、CI で task-id 解決 step が必要。
- `docs-indexer` 実行後に差分が残ると、ドキュメント更新漏れを早期検知できる。

## 5. 結論 (Conclusion) (必須)

- `.github/workflows/ci-framework.yml` を新規追加する。
- CI の実行順は `docs-indexer` -> INDEX差分検知 -> latest task-id 解決 -> `check_consistency`。
- latest task-id が一意に解決できない場合は CI を失敗させる。

## 6. 未解決事項 (Open Issues) (必須)

- task-id 解決を「最新1件」から「複数対象」へ拡張するかは今後検討。

## 7. 次のアクション (Next Action) (必須)

1. workflow ファイルを実装する。
2. CI 統合内容を spec/docs に反映する。
3. ローカルで `docs-indexer` と `check_consistency` を実行し整合性を確認する。

## 8. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__automation-tools-ci-integration/request.md`
- spec: `work/2026-02-18__automation-tools-ci-integration/spec.md`
