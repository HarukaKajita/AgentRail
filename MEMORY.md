# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__ci-profile-schema-version-governance-gate
- タイトル: CI Profile Schema Version Governance Gate
- 状態: planned
- 最終更新日時: 2026-02-19T18:49:17+09:00
- 担当: codex

## 2. 今回の目的

- `schema_version` 更新運用（2.x 以降）を CI で自動強制する。
- profile schema 変更時の versioning ミスを fail-fast で検出する。
- 起票から `spec.md` 確定までを完了する。

## 3. 完了済み

- `work/2026-02-19__ci-profile-schema-version-governance-gate/` を作成し、必須6ファイルを作成した。
- `request.md` で要望範囲（直要求/潜在要求/非要求）と境界条件を確定した。
- `investigation.md` で CI 現状と未実装ギャップを調査し、実装候補を定義した。
- `spec.md` で AC-001〜AC-006 とテスト要件（Unit/Integration/Regression/Manual）を確定した。
- `docs/operations/validator-enhancement-backlog.md` に VE-006 を `planned` で追加した。
- `docs/operations/high-priority-backlog.md` に本タスクを優先タスクとして追加した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: schema version ガバナンスは CI で強制し、違反時は workflow を失敗させる。
- 決定内容: 判定ルールは少なくとも「schema file 変更時の version 更新必須」「supported list 整合必須」「breaking change 時 major 増分必須」を含む。
- 根拠資料:
  - `.github/workflows/ci-framework.yml`
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. `tools/profile-validate/enforce-schema-version-governance.ps1` を実装する。
2. `.github/workflows/ci-framework.yml` へ governance step を追加する。
3. policy/spec/runbook/index を実装結果に合わせて更新し、review で AC を判定する。

## 7. 参照先

- `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/investigation.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/plan.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか
- [x] 次アクションが実行可能な粒度か
