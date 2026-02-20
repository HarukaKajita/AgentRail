# Investigation: 2026-02-20__refactor-tools-to-profile-driven-runtime-paths

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/request.md`
- 理解ポイント:
  - 調査では再現条件と設計方針を分離して記録する。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: tools の固定パス参照を profile 起点へ統一
- 目的: work/docs 直書きを廃止し、.agentrail/work レイアウトでも同一挙動にする。
- 依存: `2026-02-20__add-runtime-installer-with-agentrail-work-layout`

## 2. 仮説 (Hypothesis) (必須)

- `workflow.task_root` / `workflow.docs_root` / `workflow.runtime_root` を共通解決して各ツールへ適用すれば、導入先差分を吸収できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `project.profile.yaml`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
  - `tools/ci/resolve-task-id.ps1`
  - `tools/improvement-harvest/*.ps1`
  - `tools/commit-boundary/*.ps1`
- 実施した確認:
  - 固定パス参照 (`work/`, `docs/`) の分布を確認する。
  - profile 起点化の影響範囲をツール単位で切り分ける。
  - 後方互換（既存 `work/` 運用）を維持する移行順序を定義する。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - installer 実装により導入先 profile は `.agentrail/work` を保持できるようになった。
  - 主要ツールは現時点で `work/` / `docs/` 直書きが残っている。
- 推測:
  - 共通の profile path 解決関数を導入して段階置換するのが最も安全。

## 5. 提案オプション (必須)

1. 最小変更:
   - 一部ツールのみ profile 化する。
2. バランス（推奨）:
   - 主要ツールをまとめて profile 起点化し、回帰検証を同時実施する。
3. 強化:
   - 全ツール + CI 仕様変更を同時に完了する。

## 6. 推奨案 (必須)

- 推奨: 2. バランス
- 理由:
  - 影響範囲を制御しつつ導入先整合を確保できる。

## 7. 結論 (Conclusion / 結論) (必須)

- task_root/docs_root/runtime_root を共通解決する実装へ移行する。

## 8. 未解決事項 (必須)

- AGENTS runtime 記述分離タスクとの境界整理。

## 9. 次アクション (必須)

1. 受入条件を具体化し、対象ツール一覧を確定する。
2. profile path 解決ヘルパーを実装する。
3. 主要ツールを順次置換して回帰検証する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/request.md`
- spec: `work/2026-02-20__refactor-tools-to-profile-driven-runtime-paths/spec.md`
