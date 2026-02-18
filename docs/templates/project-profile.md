# project.profile.yaml 記入ガイド

`project.profile.yaml` は技術スタック差分を吸収するための設定です。  
フレームワーク本体はこのファイルを参照し、特定スタック依存を避けます。

## 1. 必須キー

source of truth:
- `tools/profile-validate/profile-schema.json`

主要キー（抜粋）:
- `schema_version`
- `commands.build.command`
- `commands.test.command`
- `commands.format.command`
- `commands.lint.command`
- `paths.source_roots`
- `review.required_checks`

`project.profile.yaml` の厳密な required key 一覧は validator schema（`tools/profile-validate/profile-schema.json`）を参照する。

## 2. 記入ルール

1. すべて実行可能なコマンドを記載する。
2. 不要なコマンドでも `N/A` ではなく代替運用をコメントで明記する。
3. 推測で書かず、実プロジェクトの事実を記入する。
4. `schema_version` は `tools/profile-validate/profile-schema.json` の `supported_profile_schema_versions` に含まれる値を使う。

## 3. 例（Unity、参考）

```yaml
commands:
  build:
    command: "Unity -batchmode -quit -projectPath . -executeMethod BuildScript.Run"
  test:
    command: "Unity -batchmode -quit -projectPath . -runTests -testPlatform editmode"
```

## 4. 例（Node.js、参考）

```yaml
commands:
  build:
    command: "pnpm build"
  test:
    command: "pnpm test"
```

## 5. 運用上の注意

- ここに未設定項目がある場合、実装を進めずに不足情報を質問する。
