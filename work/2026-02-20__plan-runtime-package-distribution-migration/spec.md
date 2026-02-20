# 仕様書: 2026-02-20__plan-runtime-package-distribution-migration

## 記入ルール

- `[空欄禁止]` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-runtime-package-distribution-migration/request.md`
  - `work/2026-02-20__plan-runtime-package-distribution-migration/investigation.md`
- 理解ポイント:
  - 単一リポジトリ方針を維持し、外部利用への分離強化を優先する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__plan-runtime-package-distribution-migration
- タイトル: dist/runtime から package 配布へ移行する計画タスク起票
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: work/2026-02-20__plan-runtime-package-distribution-migration/request.md

## 2. 背景と目的 [空欄禁止]

- 背景: 外部利用時に framework 開発資産と runtime 必要資産が混在する。
- 目的: 実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- package 化の受入条件・移行条件の定義
- 配布方式（copy/package）併存期間の運用方針
- release/rollback/versioning 戦略の明文化

### 3.2 Out of Scope [空欄禁止]

- package publish 実装
- レジストリ選定の最終決定

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: タスク目的に対する仕様と実装方針が docs/work に反映される。
- AC-002: 依存関係とゲート条件が backlog/state/plan で整合する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 変更対象 PowerShell スクリプトまたはドキュメント生成ロジック
- 観点: 入力条件に対して期待出力が得られる
- 合格条件: 想定ケースで PASS、異常系で適切に FAIL

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: tools と project.profile.yaml の連携
- 観点: .agentrail/work 前提でも一貫した動作となる
- 合格条件: 導入～検証の主要コマンドが成功する

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存の work と docs 運用フロー
- 観点: 従来の task チェック・CI チェックを壊さない
- 合格条件: 既存検証手順が継続して PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: spec と plan に定義したコマンドを順次実行して結果を確認する
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: task 目的に関係する tools, README.md, AGENTS.md, docs/operations
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:
  - 移行条件が曖昧だと package 化着手タイミングが決められない
  - 互換ポリシー不足で外部利用側に破壊的変更が波及する
- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 [空欄禁止]

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク [空欄禁止]

- request: work/2026-02-20__plan-runtime-package-distribution-migration/request.md
- investigation: work/2026-02-20__plan-runtime-package-distribution-migration/investigation.md
- plan: work/2026-02-20__plan-runtime-package-distribution-migration/plan.md
- review: work/2026-02-20__plan-runtime-package-distribution-migration/review.md
- docs:
  - `docs/operations/high-priority-backlog.md`

