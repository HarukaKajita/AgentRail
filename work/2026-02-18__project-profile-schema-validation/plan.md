# Plan: 2026-02-18__project-profile-schema-validation

## 1. 対象仕様

- `work/2026-02-18__project-profile-schema-validation/spec.md`

## 2. Execution Commands

- validate profile: `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`

## 3. 実施ステップ

1. profile validator を実装する
2. 必須キー・禁止値検証を追加する
3. CI workflow に組み込む
4. docs / review / state を更新する

## 4. 変更対象ファイル

- `tools/profile-validate/validate.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/phase2-automation-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__project-profile-schema-validation/*`

## 5. リスクとロールバック

- リスク: パース実装差異で誤判定
- ロールバック: validator を warning モードで暫定運用

## 6. 完了判定

- AC-001〜AC-004 をすべて PASS
