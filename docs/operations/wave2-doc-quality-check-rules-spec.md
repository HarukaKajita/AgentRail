# Wave 2 Spec: Doc Quality Check Rules

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `docs/operations/wave1-doc-work-cross-link-normalization.md`
  - `work/2026-02-20__wave2-spec-doc-quality-check-rules/spec.md`
- 理解ポイント:
  - 本資料は docs 品質チェックを warning/fail で段階導入するための仕様定義である。

## 1. ルールセット

1. DQ-001: 前提知識セクション必須
   - 対象: docs/operations の must 対象資料
   - 判定: `前提知識` 見出しと参照資料が存在する
2. DQ-002: 関連資料リンク必須
   - 対象: done task の `spec.md` / 主要 operations docs
   - 判定: `docs/*` と `work/*` の双方向導線が存在する
3. DQ-003: docs/INDEX 同期
   - 対象: 新規/更新 docs
   - 判定: `docs/INDEX.md` に導線が存在する
4. DQ-004: backlog/state 依存整合
   - 対象: high-priority-backlog と task state
   - 判定: depends_on と gate 状態が一致する

## 2. 段階導入方針

1. Wave 2-1 (warning mode)
   - ルール違反は CI を失敗させず warning として記録する。
2. Wave 2-2 (fail mode)
   - warning で観測された課題を解消後、違反を fail として扱う。

## 3. 判定出力

- 最低出力項目:
  - rule_id
  - severity (`warning` / `error`)
  - file
  - reason
- 集計出力:
  - total_rules
  - warning_count
  - error_count

## 4. 後続タスクへの引き継ぎ

- `2026-02-20__wave2-implement-doc-quality-warning-mode`
  - warning 出力形式と運用手順を実装する。
- `2026-02-20__wave2-enforce-doc-quality-fail-mode`
  - fail 昇格の適用条件とロールバックを実装する。
