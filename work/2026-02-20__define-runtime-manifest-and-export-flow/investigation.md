# Investigation: 2026-02-20__define-runtime-manifest-and-export-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/request.md`
- 理解ポイント:
  - 調査では再現条件と設計方針を分離して記録する。

## 1. 調査対象 [空欄禁止]

- 課題: runtime 配布境界（manifest）と dist/runtime export の確立
- 目的: 配布対象を allowlist 化し、外部利用時に不要な開発用ファイル混入を防止する。
- 依存: なし

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `framework.runtime.manifest.yaml` を SSOT にし、`tools/runtime/export-runtime.ps1` で apply/check を提供すれば、手動削除なしで runtime 配布物を再生成できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `README.md`
  - `project.profile.yaml`
  - `tools/consistency-check/check.ps1`
  - `tools/docs-indexer/index.ps1`
- 実施した確認:
  - 外部利用時に不要資産（`work/*`, `archive/*`, 開発履歴系 docs）が混在する現状を確認した。
  - PowerShell 標準環境で `ConvertFrom-Yaml` が利用できないため、manifest はシンプル YAML 形式を独自解析する方針を確認した。
  - runtime 配布物へ初期テンプレートを上書き配置するため、seed ファイル方式（`<source> => <destination>`）を採用した。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - `framework.runtime.manifest.yaml` で include/seed/exclude の境界を定義できる。
  - `tools/runtime/export-runtime.ps1 -Mode apply` で dist/runtime を再生成できる。
  - `tools/runtime/export-runtime.ps1 -Mode check` で配布物ドリフトを検出できる。
  - `tools/runtime/export-runtime.ps1 -Mode apply -DryRun` でコピー計画を確認できる。
- 推測:
  - 次タスクで installer を追加すれば .agentrail/work 前提の導入フローへ接続できる。

## 5. 提案オプション [空欄禁止]

1. 最小変更:
   - manifest と export スクリプトのみ追加する。
2. バランス（推奨）:
   - manifest/export に加えて seed docs と運用ガイドを同時更新する。
3. 強化:
   - installer と package 化まで同時実装する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. バランス
- 理由:
  - 本タスク範囲で runtime 境界を実運用可能な形で確立できる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- runtime 配布の基礎として、manifest + seed + export(check/apply) の3点を導入する方針は妥当であり、実行確認でも成立した。

## 8. 未解決事項 [空欄禁止]

- .agentrail/work への導入自動化は次タスク（installer）で実装する。
- package 配布の実施時期は未定であり、計画タスクで移行条件を定義する。

## 9. 次アクション [空欄禁止]

1. `2026-02-20__add-runtime-installer-with-agentrail-work-layout` を開始する。
2. workflow.task_root/docs_root/runtime_root の profile 起点化へ進む。
3. AGENTS runtime 必須記述の分離タスクを実行する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__define-runtime-manifest-and-export-flow/request.md`
- spec: `work/2026-02-20__define-runtime-manifest-and-export-flow/spec.md`


