# Investigation: 2026-02-20__plan-runtime-package-distribution-migration

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-runtime-package-distribution-migration/request.md`
- 理解ポイント:
  - 調査では再現条件と設計方針を分離して記録する。

## 1. 調査対象 [空欄禁止]

- 課題: dist/runtime から package 配布へ移行する計画タスク起票
- 目的: 実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。
- 依存: `2026-02-20__refactor-tools-to-profile-driven-runtime-paths`, `2026-02-20__split-framework-runtime-rules-from-agents`

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 境界（runtime/development）を明文化し、実装導線を統一すれば混在を抑止できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - README.md
  - project.profile.yaml
  - docs/operations/high-priority-backlog.md
- 実施した確認:
  - 現行導入手順の clone 前提と固定パス依存を確認する。
  - 2026-02-20__plan-runtime-package-distribution-migration の実装対象と非対象を切り分ける。
  - 依存タスクの完了条件とゲート条件を確認する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 外部利用時に不要な開発資産が混在する余地がある。
  - パス固定スクリプトの影響で .agentrail/work 前提運用へ即時移行できない。
- 推測:
  - 段階分割で実装すれば後方互換を維持しながら移行可能。

## 5. 提案オプション [空欄禁止]

1. 最小変更:
   - ドキュメント修正のみ実施する。
2. バランス（推奨）:
   - 仕様・ツール・導入手順を対象に段階改修する。
3. 強化:
   - package 化まで一括実装する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. バランス
- 理由:
  - 現実的な実装負荷で分離品質を改善できる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクは単一リポジトリ前提の分離強化を進める実装単位として妥当である。

## 8. 未解決事項 [空欄禁止]

- package 配布の最終方式は将来タスクで確定する。

## 9. 次アクション [空欄禁止]

1. spec.md で受入条件とテスト要件を確定する。
2. plan.md で plan-draft -> depends_on gate -> plan-final を確定する。
3. 実装後に eview.md で検証結果を記録する。

## 10. 関連リンク [空欄禁止]

- request: work/2026-02-20__plan-runtime-package-distribution-migration/request.md
- spec: work/2026-02-20__plan-runtime-package-distribution-migration/spec.md
"@

   = (@{Id=2026-02-20__plan-runtime-package-distribution-migration; Title=dist/runtime から package 配布へ移行する計画タスク起票; Goal=実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。; Category=flow; Severity=low; DependsOn=System.Object[]; ScopeIn=System.Object[]; ScopeOut=System.Object[]; Risks=System.Object[]}.ScopeIn | ForEach-Object { "- " }) -join "
"
   = (@{Id=2026-02-20__plan-runtime-package-distribution-migration; Title=dist/runtime から package 配布へ移行する計画タスク起票; Goal=実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。; Category=flow; Severity=low; DependsOn=System.Object[]; ScopeIn=System.Object[]; ScopeOut=System.Object[]; Risks=System.Object[]}.ScopeOut | ForEach-Object { "- " }) -join "
"
   = (@{Id=2026-02-20__plan-runtime-package-distribution-migration; Title=dist/runtime から package 配布へ移行する計画タスク起票; Goal=実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。; Category=flow; Severity=low; DependsOn=System.Object[]; ScopeIn=System.Object[]; ScopeOut=System.Object[]; Risks=System.Object[]}.Risks | ForEach-Object { "- " }) -join "
"

   = @"
# 仕様書: 2026-02-20__plan-runtime-package-distribution-migration

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
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



### 3.2 Out of Scope [空欄禁止]



## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: タスク目的に対する仕様と実装方針が docs/work に反映される。
- AC-002: 依存関係とゲート条件が backlog/state/plan で整合する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 変更対象 PowerShell スクリプトまたはドキュメント生成ロジック
- 観点: 入力条件に対して期待出力が得られる
- 合格条件: 想定ケースで PASS、異常系で適切に FAIL

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 	ools/* と project.profile.yaml の連携
- 観点: .agentrail/work 前提でも一貫した動作となる
- 合格条件: 導入～検証の主要コマンドが成功する

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存の work/* / docs/* 運用フロー
- 観点: 従来の task チェック・CI チェックを壊さない
- 合格条件: 既存検証手順が継続して PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: spec/plan に定義したコマンドを順次実行して結果を確認する
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: task 目的に関係する 	ools/, README.md, AGENTS.md, docs/operations/*
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:

- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 [空欄禁止]

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク [空欄禁止]

- request: work/2026-02-20__plan-runtime-package-distribution-migration/request.md
- investigation: work/2026-02-20__plan-runtime-package-distribution-migration/investigation.md
- plan: work/2026-02-20__plan-runtime-package-distribution-migration/plan.md
- review: work/2026-02-20__plan-runtime-package-distribution-migration/review.md
- docs:
  - docs/operations/high-priority-backlog.md
"@

   = if (@{Id=2026-02-20__plan-runtime-package-distribution-migration; Title=dist/runtime から package 配布へ移行する計画タスク起票; Goal=実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。; Category=flow; Severity=low; DependsOn=System.Object[]; ScopeIn=System.Object[]; ScopeOut=System.Object[]; Risks=System.Object[]}.DependsOn.Count -eq 0) { 'なし' } else { `2026-02-20__refactor-tools-to-profile-driven-runtime-paths`, `2026-02-20__split-framework-runtime-rules-from-agents` }
   = if (@{Id=2026-02-20__plan-runtime-package-distribution-migration; Title=dist/runtime から package 配布へ移行する計画タスク起票; Goal=実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。; Category=flow; Severity=low; DependsOn=System.Object[]; ScopeIn=System.Object[]; ScopeOut=System.Object[]; Risks=System.Object[]}.DependsOn.Count -eq 0) { '依存なしのため plan-ready 判定を採用する。' } else { '依存タスクがすべて done になるまで dependency-blocked を維持する。' }

   = @"
# Plan: 2026-02-20__plan-runtime-package-distribution-migration

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-runtime-package-distribution-migration/spec.md`
- 理解ポイント:
  - 実装前に depends_on とゲート状態を確認する。

## 1. 対象仕様

- work/2026-02-20__plan-runtime-package-distribution-migration/spec.md

## 2. plan-draft

- 目的: 実施時期未定の package 化に備え、移行条件・互換ポリシー・実装ステップを先行定義する。
- 実施項目:
  1. 現行構成の問題箇所を再確認し、変更境界を固定する。
  2. spec の受入条件を満たす実装差分を最小単位で設計する。
  3. 実装後の検証コマンドとレビュー観点を確定する。
- 成果物: 変更対象一覧、実装手順、検証手順

## 3. depends_on gate

- 依存: 
- 判定方針: 

## 4. plan-final

- 実装順序:
  1. 仕様・ルールの更新
  2. スクリプト/設定の更新
  3. docs/index/backlog/state の整合更新
- 検証順序:
  1. pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration
  2. pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration
  3. 影響範囲の回帰チェック
- ロールバック: 対象コミットを単位に戻し、spec と plan を再確認して再実装する

## 5. Execution Commands

- pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration
- pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__plan-runtime-package-distribution-migration
- pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check

## 6. 完了判定

- 受入条件の判定結果を work/2026-02-20__plan-runtime-package-distribution-migration/review.md に記録する。
- 対象 task の検証コマンドが成功する。
