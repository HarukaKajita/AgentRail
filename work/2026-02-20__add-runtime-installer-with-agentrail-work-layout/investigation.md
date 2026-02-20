# Investigation: 2026-02-20__add-runtime-installer-with-agentrail-work-layout

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md`
- 理解ポイント:
  - 調査では再現条件と設計方針を分離して記録する。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: .agentrail/work 前提の runtime インストーラ導入
- 目的: 外部利用時の成果物を .agentrail/work に統一し、導入をスクリプト化する。
- 依存: `2026-02-20__define-runtime-manifest-and-export-flow`

## 2. 仮説 (Hypothesis) (必須)

- runtime export 済み成果物を installer で導入先に展開し、profile の task_root を .agentrail/work に更新すれば外部利用の分離運用を開始できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `tools/runtime/export-runtime.ps1`
  - `framework.runtime.manifest.yaml`
  - `project.profile.yaml`
- 実施した確認:
  - 依存 task（manifest/export）が done であることを確認する。
  - installer で必要な処理（コピー、profile 更新、dry-run）を定義する。
  - 一時導入先 .tmp/runtime-install-smoke で検証観点を確定する。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - `tools/runtime/install-runtime.ps1` で dry-run / apply の両方を実行できる。
  - apply 後に導入先へ `.agentrail/work/.gitkeep` が生成される。
  - 導入先 `project.profile.yaml` の `workflow.task_root` と `workflow.runtime_root` が更新される。
  - `paths.source_roots` / `paths.artifacts` の `work` も `.agentrail/work` へ揃えられる。
- 推測:
  - 次タスクで tools を profile 起点化すれば、導入先での整合がさらに向上する。

## 5. 提案オプション (必須)

1. 最小変更:
   - コピー機能のみ実装する。
2. バランス（推奨）:
   - コピー + profile 更新 + dry-run + 競合検出を実装する。
3. 強化:
   - path 解決改修まで同時に実装する。

## 6. 推奨案 (必須)

- 推奨: 2. バランス
- 理由:
  - 本タスク範囲で導入実効性を確保しつつ、次タスクへ分離できる。

## 7. 結論 (Conclusion / 結論) (必須)

- installer は `.agentrail/work` を導入先へ作成し、profile を更新する方式で妥当。

## 8. 未解決事項 (必須)

- profile 起点で全ツールを動かす対応は次タスクで実施する。

## 9. 次アクション (必須)

1. `2026-02-20__refactor-tools-to-profile-driven-runtime-paths` を開始する。
2. workflow.task_root/docs_root/runtime_root を参照して tools が動くよう改修する。
3. 変更後に installer smoke を再実行して整合を確認する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md`
- spec: `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md`


