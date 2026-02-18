# Investigation: 2026-02-18__phase2-automation-implementation

## 1. 調査対象 [空欄禁止]

- Phase 2 設計を実装へ落とす際の最小構成と失敗条件の具体化。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- PowerShell 単体で docs 走査・Markdown解析・整合チェックが実装できる。
- `docs/INDEX.md` は見出し単位で部分更新すれば手動記述を保護できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `docs/specs/phase2-automation-spec.md`
  - `docs/INDEX.md`
  - `project.profile.yaml`
- 実施した確認:
  - 現在の docs 構造とファイル命名
  - task ドキュメントの形式
  - profile コマンド体系

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- docs の管理対象カテゴリは見出し `## 2`〜`## 5` で固定されている。
- task 情報は `work/<task-id>/` の6ファイルで完結している。
- profile には build/test/format/lint しかなく、自動化コマンドは未登録。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `tools/docs-indexer/index.ps1` と `tools/consistency-check/check.ps1` の2本立てで実装する。
- `project.profile.yaml` へ `index_docs` と `check_consistency` を追加する。
- CI 連携は仕様上の確定までに留め、実装は後続へ分離する。

## 6. 未解決事項 [空欄禁止]

- CI 実行時の task ID 自動解決方式。

## 7. 次アクション [空欄禁止]

1. docs-indexer を実装する。
2. consistency-check を実装する。
3. 自動化コマンドを profile に反映する。
4. docs と review を更新して完了判定を行う。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-18__phase2-automation-implementation/request.md`
- spec: `work/2026-02-18__phase2-automation-implementation/spec.md`
