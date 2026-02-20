# Runtime Package Distribution Migration Plan

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `project.profile.yaml`
  - `framework.runtime.manifest.yaml`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-distribution-export-guide.md`
  - `docs/operations/runtime-installation-runbook.md`
- 理解ポイント:
  - 現行の copy 配布運用を維持しながら、package 配布への段階移行条件を明確化する。

## 1. 目的

- `dist/runtime` コピー配布から package 配布へ移行するための条件、互換ポリシー、実施手順を定義する。

## 2. 現状整理

- 現行配布方式: `tools/runtime/export-runtime.ps1` で `dist/runtime` を生成して配布。
- 導入方式: `tools/runtime/install-runtime.ps1` で target にコピーし、`workflow.task_root` を `.agentrail/work` へ設定。
- 制約: 単一リポジトリ運用を維持し、外部導入側への破壊的変更を避ける。

## 3. 移行開始条件

1. runtime 配布対象が `framework.runtime.manifest.yaml` で安定運用できていること。
2. profile 起点パス解決が主要 tools で統一されていること。
3. AGENTS runtime ルールの分離と参照導線が確立されていること。
4. package 配布方式の署名、公開先、アクセス制御の運用責任者が決定していること。

## 4. 互換ポリシー

1. 併存期間は copy/package の両方式をサポートする。
2. 併存期間中は install 手順を一本化し、内部で配布ソースのみ切り替える。
3. 廃止予告期間を 2 リリース分確保し、copy 配布終了日を事前通知する。
4. 破壊的変更は `schema_version` と release note に明示する。

## 5. 実施フェーズ

1. Phase 0: 計画確定
   - 本資料の合意、責任者決定、移行 KPI 定義
2. Phase 1: package 配布 PoC
   - package 作成と取得フローを検証環境で評価
3. Phase 2: 併存運用
   - copy/package の両ルートを CI で検証
4. Phase 3: package 既定化
   - install の既定ソースを package に切替
5. Phase 4: copy 配布廃止
   - 廃止予告を完了し copy ルートを削除

## 6. リリース/ロールバック戦略

- リリース:
  - package 版は段階リリース（internal -> pilot -> general）で進める。
  - 各段階で install 成功率とロールバック率を観測する。
- ロールバック:
  - package 障害時は copy 配布ルートを即時再有効化する。
  - rollback 手順は `runtime-installation-runbook` へ同時反映する。

## 7. リスクと対策

- リスク: package 公開基盤の障害で導入が停止する。
  - 対策: copy 配布をバックアップ経路として一定期間維持する。
- リスク: バージョン互換の誤判定で導入先が壊れる。
  - 対策: profile/schema バージョンの互換表を release note に明記する。
- リスク: ドキュメント導線不足で運用が分断される。
  - 対策: `AGENTS.md`, `docs/INDEX.md`, runbook を同一 PR で更新する。

## 8. 検証コマンド（計画タスク）

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 9. 関連資料

- `work/2026-02-20__plan-runtime-package-distribution-migration/spec.md`
- `docs/operations/high-priority-backlog.md`
