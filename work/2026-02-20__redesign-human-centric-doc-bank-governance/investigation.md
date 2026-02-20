# Investigation: 2026-02-20__redesign-human-centric-doc-bank-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/request.md`
- 理解ポイント:
  - 再設計対象は「資料運用方針」と「それを支える更新プロセス」である。

## 1. 調査対象 [空欄禁止]

- 課題: 人間理解を主目的に据えた資料バンク運用へ方針転換する。
- 目的: 目的・設計・実装・運用・関連資料を常時同期する設計原則を定義する。
- 依存: なし

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 資料バンクの情報モデル（目的/使い方/仕組み/実装/関連）と更新責務を明示すれば、人間の理解速度を維持できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/operations/high-priority-backlog.md`
  - `tools/consistency-check/check.ps1`
  - `tools/docs-indexer/index.ps1`
- 実施した確認:
  - 現行ルールが再現性中心であり、理解容易性の明示が弱い箇所を抽出する。
  - docs の更新導線と機械検証範囲を確認する。
  - 方針再設計と移行計画を別タスク化する妥当性を確認する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 現行ルールは workflow 固定化と整合チェックが強い一方、「人間理解」を第一目的としては明示していない。
  - docs/INDEX と task 文書の整合はあるが、目的/実装/関連資料の網羅性を定量管理する規則は未整備。
- 推測:
  - 情報モデルと品質ゲートを先に再定義し、その後に既存資産を段階移行する方式が最も安全。

## 5. 提案オプション [空欄禁止]

1. 最小変更:
   - AGENTS/README の目的文のみ修正する。
2. 設計先行（推奨）:
   - 方針再設計タスクで情報モデルと運用規約を確定し、移行タスクへ受け渡す。
3. 一括移行:
   - 設計確定前に全資料をまとめて再編する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. 設計先行
- 理由:
  - 変更影響を局所化し、レビュー可能な粒度で移行を進められる。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- まず方針再設計タスクを起票し、次段で既存資料/仕組みの移行計画タスクを依存付きで起票する。

## 8. 未解決事項 [空欄禁止]

- 人間理解の品質指標（網羅率/更新遅延/導線整合）のしきい値は次段で確定する。

## 9. 次アクション [空欄禁止]

1. 再設計計画の spec/plan を確定する。
2. 移行計画タスクを depends_on 付きで起票する。
3. backlog と state を同期する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__redesign-human-centric-doc-bank-governance/request.md`
- spec: `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
