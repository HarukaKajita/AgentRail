# Investigation: 2026-02-20__plan-migration-to-human-centric-doc-bank

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__plan-migration-to-human-centric-doc-bank/request.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 移行設計では「優先度」「依存」「検証容易性」の3軸で分割する。

## 1. 調査対象 [空欄禁止]

- 課題: 既存 docs/運用仕組みを新しい人間理解中心設計へ移行する実行計画を作成する。
- 目的: 高精度に進行できるフェーズ分割とタスク分割を定義する。
- 依存: `2026-02-20__redesign-human-centric-doc-bank-governance`

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 資産棚卸し -> ギャップ補正 -> ルール適用 -> 継続監査の順で移行すれば、品質と速度を両立できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `docs/INDEX.md`
  - `docs/operations/*.md`
  - `work/*/spec.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 実施した確認:
  - docs と work の現行構造を対象カテゴリ別に整理する。
  - 既存ツールで検証可能な項目と不足項目を切り分ける。
  - 段階移行の依存順序と rollback ポイントを設計する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - docs 資料は豊富だが、目的/使い方/実装対応の網羅度を一律に保証する規約は弱い。
  - consistency/state-validate は構造整合に強く、内容網羅の品質評価は限定的である。
- 推測:
  - 移行初期は docs 情報モデル準拠チェックリストを導入し、次段で自動検証を拡張するのが妥当。

## 5. 提案オプション [空欄禁止]

1. docs 先行:
   - 文書移行のみ先に実施し、ツールは後追い。
2. バランス（推奨）:
   - docs/運用ルール/検証手順を同時に段階設計し、実装タスクへ分配。
3. ツール先行:
   - 自動検証を先に作り、文書改訂を追随。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. バランス
- 理由:
  - 移行中の品質担保と実装負荷のバランスが良い。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- Task A を gate として、移行計画をフェーズ単位で分割起票する方式で進める。

## 8. 未解決事項 [空欄禁止]

- 自動検証へ組み込む品質指標（網羅率など）の算出方式。

## 9. 次アクション [空欄禁止]

1. spec でフェーズ定義と成果物定義を確定する。
2. plan で実施順序、ゲート、タスク分割を定義する。
3. backlog で依存付き優先表示に反映する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/request.md`
- spec: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/spec.md`
