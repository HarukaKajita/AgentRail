# フレームワーク設計と実装

**User:** Haruka Kajita (kajitaj63b3@gmail.com)  
**Created:** 2/18/2026 17:05:02  
**Updated:** 2/18/2026 17:16:03  
**Exported:** 2/18/2026 17:16:58  
**Link:** [https://chatgpt.com/c/699572a5-c2c8-83a9-9bee-7576e1df430c](https://chatgpt.com/c/699572a5-c2c8-83a9-9bee-7576e1df430c)  

## Prompt:
開発ワークフローと自動化.md

ファイル

このファイルはCodexCLIやClaudeCodeを使用した開発をより効率的で堅牢にするためのフレームワークの思案を記述したファイルです。このファイルの内容を読んで下さい。 次に、このフレームワークを実現する為に必要な構成要素やファイルを洗い出して、役割とそれを正確に生成させるためのプロンプトをまとめて作成して下さい。一度にすべての要素をまとめるのが合理的でない場合は複数回の会話の中で最良の結果を得られるように作成して下さい。 実際の開発リポジトリに追加して、作成してもらった内容を基にCodexCLIに実装を依頼しますので、それを踏まえて最適な形になるように結果を出力して下さい。

## Response:
思考時間: 1m 30s

読みました。あなたの狙いは明確で、方向性は正しいです：  
「**開発の全工程（要望→調査→要件→計画→実装→テスト→レビュー→資料更新）を、エージェントが“必ず”踏むように固定**し、さらに**資料（仕様・意思決定・制約・関連リンク）をSSOT（Single Source of Truth）として常に整合**させる」。加えて長時間稼働の劣化に備えて **MEMORY.md に状態を退避**し、**SubAgent相当**で工程分割してコンテキストを節約する、という話。

開発ワークフローと自動化

ただし、これを「フレームワーク」として機能させるには、**“資料を残す”という精神論**では足りません。  
**（1）ファイル構造**、**（2）テンプレ**、**（3）チェック機構（自動検査）**、\*\*（4）エージェントへの強制ルール（AGENTS.md / Skills）\*\*が揃わないと、すぐ形骸化します。

以下に、**実装に必要な構成要素とファイル**を「最小で回るセット（Phase 1）」と「堅牢化セット（Phase 2）」に分けて洗い出し、\*\*CodexCLIにそのまま投げられる“生成プロンプト”\*\*も一緒に出します。  
（Codexの `AGENTS.md` と `Skills` の仕組みはOpenAI公式の仕様に合わせています。[OpenAI Developers+1](https://developers.openai.com/codex/guides/agents-md/?utm_source=chatgpt.com) Claude Code側は `CLAUDE.md` とHooks/Pluginの文化があるので、後段で“両対応の落とし所”に寄せます。[Claude Code+1](https://code.claude.com/docs/en/memory?utm_source=chatgpt.com)）

* * *

あなたのメモで未確定な「致命点」
----------------

ここを埋めないと、フレームワークは高確率で壊れます。

1.  **テスト要件の具体化が未定義**  
    あなた自身が「ここもっと具体化したい」と書いてる通り、ここが曖昧だと “テストを書かない言い訳” が無限に発生します。
    開発ワークフローと自動化
    → **テンプレで強制**し、CIで“空欄を落とす”必要がある。
2.  **「資料と実装の整合」をどう判定するかが未定義**  
    「不整合が無いか定期チェック」とあるが、手動チ
    開発ワークフローと自動化
    開発ワークフローと自動化
    → 最低限の\*\*機械判定（リンク切れ / 参照ファイル存在 / 仕様IDの参照 / TODO残存）\*\*を用意する。
3.  **サブエージェント分割の“境界”が未定義**  
    開発ワークフローと自動化
    開発ワークフローと自動化
    → 「調査」「要件」「計画」「実装」「テスト」「レビュー」を**役割分離**し、それぞれに“渡す入力”と“出す成果物”を固定する。

* * *

Phase 1（最小で回る

開発ワークフローと自動化

るのが合理的\*\*です。理由：最初から自動化を盛ると、テンプレや規約が固まらないままスクリプトだけ増えて破綻しがち。
----------------------------------------------------------------------------------------

### 1) ルート指示：`AGENTS.md`

*   **役割**：Codexが作業開始前に必ず読む “プロジェクト憲法”。階層で上書きできるのが強み。[OpenAI Developers+1](https://developers.openai.com/codex/guides/agents-md/?utm_source=chatgpt.com)
*   **必須内容**：ワークフロー固定（Plan→Work→Test→Review→Docs更新）、危険コマンド禁止、成果物フォーマット、Docs更新の強制。

### 2) 状態退避：`MEMORY.md`

*   **役割**：長時間実行での圧縮・劣化対策として、現在地・決定事項・次アクション・未解決点を退避。
    開発ワークフローと自動化
*   **注意**：ここは“日記”にすると毒。テンプレ化して機械的に更新させる。

### 3) 仕様・意思決定バンク：`docs/` 以下（SSOT）

最低限これだけ要ります。

*   `docs/README.md`（資料バンクの使い方）
*   `docs/INDEX.md`（検索導線：後で自動生成にする前提で手動でも
    開発ワークフローと自動化
    spec.md\`（仕様テンプレ：背景/目的/スコープ/非スコープ/受入条件/テスト要件/UX/依存）
    *   `adr.md`（ADR: Architecture Decision Record：なぜその設計か）
    *   `investigation.md`（調査テンプレ：仮説/観測/結論/未解決）
*   `docs/decisions/`（ADR置き場）
*   `docs/specs/`（仕様置き場）
*   `docs/investigations/`（調査ログ）

あなたが言う「仕様以外の重要情報も残す」「関連資料リンクを持たせる」「インデックスが必要」を、フォルダ設計で固定します。

開発ワークフローと自動化

### 4) タスク単位の作業場所：`work/`（または `tasks/`）

*   `work/YYYY-MM-DD__short-title/`
    *   `request.md`（要望の原文・整理）
    *   `investigation.md`
    *   `spec.md`
    *   `plan.md`
    *   \`rev
        開発ワークフローと自動化
        ：state, owner, updated\_at）

これがあると、SubAgentに渡すコンテキストが\*\*「このフォルダ見ろ」で済む\*\*ので劇的に安定します（あなたの狙い通り）。

開発ワークフローと自動化

### 5) Skills（Codex）：`agents/skills/*`

OpenAI公式のSkills形式に合わせます（`SKILL.md` + 任意スクリプト）。[OpenAI Developers](https://developers.openai.com/codex/skills/?utm_source=chatgpt.com)  
Phase 1では\*\*“実装スキル”より“手順を守らせるスキル”\*\*が効きます。

最低限：

*   `ag:contentReference[oaicite:16]{index=16}s/SKILL.md`（不足要件を質問に変換）
*   `agents/skills/write_spec/SKILL.md`（specテンプレを埋める）
*   `agents/skills/write_test_requirements/SKILL.md`（テスト要件を必ず具体化）
*   `agents/skills/write_plan/SKILL.md`（実装計画：タスク分割・差分・影響）
*   `agents/skills/update_docs/SKILL.md`（SSOT更新チェックリスト）

> 参考：あなたが挙げた既存フレームワーク（Superpowers / Harness / compounding plugin）は、まさに「手順固定」「安全装置」「SSOT」を強化しています。
> 
> 開発ワークフローと自動化
> 
> [GitHub+3GitHub+3GitHub+3](https://github.com/obra/superpowers?utm_source=chatgpt.com)

* * *

Phase 2（堅牢化）追加要素
----------------

Phase 1が回り始めてから追加するのが合理的。

### A) 自動インデックス生成：`tools/docs-indexer`

*   `docs/INDEX.md` を**自動生成**（リンク切れ検知もここで）
*   `docs/_graph.json`（関連リンクをグラフ化して検索補助）
*   P
    開発ワークフローと自動化
    合性チェック：`tools/consistency-check`  
    最低限の機械判定：
*   spec内リンクの存在確認
*   specが参照する “実装ターゲット（ファイル/モジュール）” が実在するか
*   `TODO(REQ-xxx)` の未解決残存
*   `plan.md` が `spec.md` を参照しているか

### C) Claude Code側の補助（任意）

*   `CLAUDE.md`（Claude Codeの永続メモリとして機能）[Claude Code](https://code.claude.com/docs/en/memory?utm_source=chatgpt.com)
*   Hooks（フォーマット/危険コマンドブロック/ログ）[クラスメソッド発「やってみた」系技術メディア | DevelopersIO+1](https://dev.classmethod.jp/articles/claude-code-hooks-basic-usage/?utm_source=chatgpt.com)

さらに「両対応」を強めるなら、EveryIncの plugin 変換ツールの思想（Claudeプラグイン→Codex形式へ変換）も参考になります。[GitHub+1](https://github.com/EveryInc/compound-engineering-plugin?utm_source=chatgpt.com)

* * *

CodexCLIに投げる“生成プロンプト”パック（Phase 1）
---------------------------------

以下は **コピペ前提**で書きます。  
あなたは「まずPhase 1を一括生成」→「リポジトリに追加」→「CodexCLIで実装依頼」の流れが最短です。

### Prompt 1: Phase 1の全ファイルをスキャフォールド生成

```text
あなたはリポジトリ内に「エージェント駆動の開発ワークフロー」を固定するフレームワークを追加します。
以下の要件で、新規ファイルを作成してください（既存ファイルがある場合は変更せず、差分提案だけ出す）。

# ゴール
- 要望→調査→要件→計画→実装→テスト→レビュー→資料更新 の順序を強制できる「資料構造」と「テンプレ」を作る
- 長時間実行の劣化対策として MEMORY.md を用意する
- Codexの Skills 形式（agents/skills/*/SKILL.md）で、手順遵守用のスキルを最低限5つ用意する

# 作成するパス（新規）
- AGENTS.md
- MEMORY.md
- docs/README.md
- docs/INDEX.md （手動版でOK。後で自動生成に置換する前提の注記を書いて）
- docs/templates/spec.md
- docs/templates/adr.md
- docs/templates/investigation.md
- docs/specs/.gitkeep
- docs/decisions/.gitkeep
- docs/investigations/.gitkeep
- work/.gitkeep
- agents/skills/ask_user_questions/SKILL.md
- agents/skills/write_spec/SKILL.md
- agents/skills/write_test_requirements/SKILL.md
- agents/skills/write_plan/SKILL.md
- agents/skills/update_docs/SKILL.md

# 共通ルール（重要）
- 文章は日本語
- 略語は初出で英語フル（日本語訳）を併記する（例: SSOT (Single Source of Truth / 単一の正)）
- テンプレは「空欄で残して良いセクション」と「空欄禁止セクション」を明示する
- specテンプレには必ず「テスト要件」を入れ、具体例（ユニットテスト/統合テスト/回帰テスト/手動検証）を列挙する
- AGENTS.md には「このリポジトリでは必ず work/ 配下にタスクフォルダを作り、成果物をそこに揃える」ことを明記する
- 出力は “作成した各ファイルの内容” をそのまま提示する（説明文は最小限）

作業を開始してください。
```

### Prompt 2: `AGENTS.md` を“強制力が出る”内容に磨く（後追い改善）

```text
AGENTS.md を見直して、次を満たすように改訂案（差分）を出してください。

- Codexが作業開始時に必ず行うチェックリスト（例：該当workフォルダはあるか、specはあるか、planはあるか）
- 「spec/test要件が空欄なら実装禁止」
- 「危険コマンドの禁止」と「例外の手続き」
- 「docs/INDEX.md を更新しない変更は未完了扱い」
- 成果物の最終出力フォーマット（完了条件/次アクション/MEMORY更新）

差分パッチ形式で出してください。
```

### Prompt 3: Skillsを“薄く”保ったまま実効性を上げる

（Skillsは肥大化すると逆に破綻します。metadataだけで呼ばせるのが本筋です。[OpenAI Developers](https://developers.openai.com/codex/skills/?utm_source=chatgpt.com)）

```text
agents/skills/*/SKILL.md を改訂して、次を満たしてください。

- 各SKILL.mdは「いつ使うか」「入力」「出力」「禁止事項」を最短で書く
- 出力は必ず work/<task>/ 配下の該当テンプレファイルを更新する形にする（例: write_spec は work/<task>/spec.md を埋める）
- ask_user_questions は「質問が必要な条件」を列挙し、質問リストを生成するだけにして、推測で埋めない

差分として提示してください。
```

* * *

次の会話でやるべきこと（Phase 2に入る条件）
-------------------------

Phase 1を生成してリポジトリに入れたら、次にやるのはこれです：

1.  **あなたの実プロジェクトでタスクを1つ回す**（小さめの修正で良い）
2.  その `work/...` が埋まった実例を見て、テンプレの穴を塞ぐ
3.  そこで初めて `tools/docs-indexer` と `tools/consistency-check` を入れる（自動化）

この順序を飛ばすと、100%「使われない仕組み」が増えます。機会費用がでかい。

* * *

必要なら次のターンで、**Phase 2の “indexer / consistency-check” を Node(TypeScript) で実装するためのファイル一覧と、丸ごと生成プロンプト**まで出します。  
そのときは、あなたのリポジトリの技術スタック（Nodeの有無、テスト基盤、CIの有無）に合わせて、最短で壊れにくい構成に寄せます。

## Prompt:
このフレームワークはあらゆる開発で使えるようにします。Unity開発やTS/Node開発やそれ以外でも機能するように設計します。なので技術スタックにフレームワーク自体が依存しないようにします。

## Response:
思考時間: 28s

了解。**フレームワークを技術スタック非依存（stack-agnostic）にする**なら、設計の軸はこうです：

*   **コアは“文章（Markdown）と規約”だけで成立**させる（UnityでもTS/Nodeでも同じ）
*   自動化は **「参照実装（reference implementation）」扱い**にして、無くても運用できる
*   ただし形骸化を防ぐために、**機械で検査できる最小限の構造化データ**（YAML/JSON）を併用する

この方向は、Codexの `AGENTS.md` / Skills が “指示ファイル + 必要時ロード” という思想に寄っているのとも噛み合います。[OpenAI Developers+1](https://developers.openai.com/codex/guides/agents-md/?utm_source=chatgpt.com)  
また、Claude Code側も `CLAUDE.md` を「起動時に読む指示・文脈ファイル」として運用するのが基本なので、**両対応は設計しやすい**です。[Claude Code+1](https://code.claude.com/docs/en/memory?utm_source=chatgpt.com)  
さらに `AGENTS.md` 自体が “エージェントのREADME” というオープンな形式として広がっているので、そこに寄せるのは合理的です。[agents.md](https://agents.md/?utm_source=chatgpt.com)

* * *

スタック非依存にするための「3層アーキテクチャ」
------------------------

### Layer 0: 文書コア（必須、技術非依存）

ここは **Markdownのみ**。Unity/TS/Node/何でも同じ。

*   `AGENTS.md`（ルールと必須工程の憲法。Codexが読む）[OpenAI Developers+1](https://developers.openai.com/codex/guides/agents-md/?utm_source=chatgpt.com)
*   `CLAUDE.md`（任意。Claude Codeが読む。内容はAGENTSと同等にする）[Claude Code+1](https://code.claude.com/docs/en/memory?utm_source=chatgpt.com)
*   `MEMORY.md`（進捗の退避。テンプレ強制）
*   `docs/templates/*`（spec/adr/investigation）
*   `docs/specs` `docs/decisions` `docs/investigations`
*   `work/YYYY-MM-DD__title/*`（タスクの成果物セット）

> ADR（Architecture Decision Record / アーキテクチャ意思決定記録）は、この「スタック非依存の意思決定ログ」に最適。テンプレも標準化されているので採用しやすい。[Architectural Decision Records+2GitHub+2](https://adr.github.io/?utm_source=chatgpt.com)

### Layer 1: プロジェクト・プロファイル（必須、技術非依存）

“ビルドやテストのコマンドはプロジェクトごとに違う” を吸収する層。  
ここで **コマンドやディレクトリ規約を宣言**する。フォーマットは **YAML/JSON**。

*   `project.profile.yaml`（例）
    *   `commands.build` / `commands.test` / `commands.format` / `commands.lint`
    *   `paths.source_roots`（Unityなら `Assets/` など）
    *   `artifacts`（生成物の場所）
    *   `review.required_checks`（空欄禁止項目、受入条件の強制）

これがあると、エージェントは **技術を知らなくても「このプロジェクトの正しい手順」を機械的に辿れる**。

### Layer 2: 自動化（任意、複数実装OK）

ここは「無くても回る」が「あると堅牢」。  
しかも **1言語に依存しない**ように、以下のどれか（or複数）で提供するのが良い：

*   **POSIXシェル（/ PowerShell）**：最も普遍
*   **Python**：環境に依存しにくい
*   **Node**：Web系が強い環境で便利
*   **GitHub Actions などCI**：実行場所を固定できる

重要なのは「フレームワークの成立条件をここに置かない」こと。  
自動化は **“推奨”であり“必須”ではない**にする。

* * *

Phase 1（あなたが今作るべき最小セット）を“スタック非依存”に改造
------------------------------------

前回出した Phase 1 を、次の2点だけ変更すると「何でも使える」になります。

### 変更1：`AGENTS.md` を “抽象手順 + profile参照” にする

*   \*\*工程（Plan→Work→Test→Review→Docs）\*\*は固定
*   **具体コマンドは `project.profile.yaml` を見ろ**にする  
    これでUnityでもTSでも同じAGENTSで回る。

CodexのAGENTS.mdの運用は「正しい場所に置かれていて空じゃない」「overrideがあるとそっちが効く」といった挙動があるので、ルートに置く＋上書き運用も可能。[OpenAI Developers](https://developers.openai.com/codex/guides/agents-md/?utm_source=chatgpt.com)

### 変更2：Skillsを“実装スキル”ではなく“成果物生成スキル”に寄せる

Codex Skillsは **必要なときだけ詳細をロード**する設計（progressive disclosure）なので、  
技能の中身は「コードを書く」より「テンプレを埋める」「未確定を質問にする」に寄せる方が壊れにくい。[OpenAI Developers](https://developers.openai.com/codex/skills/?utm_source=chatgpt.com)

* * *

追加するべきファイル（スタック非依存化のための最小追加）
----------------------------

あなたが言う「どの開発でも使える」を成立させるのに、最低これが要ります。

1.  `project.profile.yaml`（必須）
2.  `CLAUDE.md`（任意だが、Claude Codeも使うなら置くべき）[Claude Code+1](https://code.claude.com/docs/en/memory?utm_source=chatgpt.com)
3.  `docs/templates/project-profile.md`（profileの書き方説明テンプレ）
4.  `agents/skills/read_profile/SKILL.md`（profileを読み、タスクで使うスキル）

> 「AGENTS.mdとCLAUDE.mdの二重管理が嫌」なら、**AGENTS.mdを正とし、CLAUDE.mdは“AGENTS.mdを読め”だけ書く**でもOK。

* * *

CodexCLIに投げる“生成プロンプト”（スタック非依存版）
-------------------------------

ここから先は、あなたがそのままCodexに流し込める形で出す。

### Prompt A：スタック非依存コアを一括生成（Phase 1 改）

```text
目的：どの技術スタック（Unity / TS-Node / その他）でも再利用できる「エージェント駆動開発フレームワーク」をリポジトリに追加する。

制約：
- フレームワーク自体は特定技術に依存しない（Node前提、Unity前提など禁止）
- “運用が成立する最小条件” は Markdown + YAML/JSON のみ
- 自動化スクリプトは作らない（Phase 2で参照実装として追加する想定）

新規作成するファイル：
- AGENTS.md（工程を固定する。具体コマンドは project.profile.yaml を参照させる）
- CLAUDE.md（任意だが作る。内容はAGENTS.mdを参照する方針）
- MEMORY.md（テンプレ形式で、状態・決定・次アクション・未解決を必須化）
- project.profile.yaml（build/test/format/lint等のコマンド、source roots、成果物、必須チェック項目を宣言）
- docs/README.md
- docs/INDEX.md（手動でもよい。後で自動生成に置換する前提の注記）
- docs/templates/spec.md（テスト要件セクションは空欄禁止。ユニット/統合/回帰/手動の観点を含める）
- docs/templates/adr.md（Michael Nygard形式に寄せる）
- docs/templates/investigation.md
- docs/templates/project-profile.md（project.profile.yamlの埋め方）
- docs/specs/.gitkeep, docs/decisions/.gitkeep, docs/investigations/.gitkeep
- work/.gitkeep
- agents/skills/ask_user_questions/SKILL.md
- agents/skills/write_spec/SKILL.md
- agents/skills/write_test_requirements/SKILL.md
- agents/skills/write_plan/SKILL.md
- agents/skills/update_docs/SKILL.md
- agents/skills/read_profile/SKILL.md

執筆ルール：
- 全文日本語
- 略語は初出で英語フル（日本語訳）併記
- 「空欄禁止セクション」を明示
- 出力は各ファイルの内容をそのまま提示（解説は最小限）

作業開始。
```

### Prompt B：Unity/TS/その他を “project.profile.yaml” で吸収するための設計強化

```text
project.profile.yaml を中心に、AGENTS.md とテンプレを調整して「技術スタック差分」を吸収できるようにする。
要件：
- commands.build/test/format/lint を必須キーとして定義
- Unity向けの例（例：Unityのバッチモードテスト）と、Node向けの例（例：pnpm test）を “例として” docs/templates/project-profile.md に載せる（フレームワーク本体はどちらにも依存しない）
- AGENTS.md は「profileが未設定なら質問を生成して止まる」を明記

差分パッチで提案して。
```

* * *

あなたが見落としがちな罠（容赦なく言う）
--------------------

「技術非依存」を掲げると、だいたいこうやって死にます：

*   **抽象化しすぎて実行不能**（結局、誰もビルドもテストも走らせない）  
    → だから `project.profile.yaml` に \*\*“実行コマンドを必須化”\*\*して逃げ道を塞ぐ
*   **自動化に寄せすぎて環境差で壊れる**  
    → 自動化はPhase 2で“参照実装”。Phase 1はテキストで成立させる
*   **テンプレが長すぎて誰も埋めない**  
    → 空欄禁止セクションは絞る（受入条件、テスト要件、非スコープ、変更影響くらいで十分）

* * *

次は、あなたのリポジトリに **Phase 1（改）** を実際に生成して入れるターンにするのが最短です。  
ファイルをこちらで直接読んで整合性まで詰めたいので、生成後の `AGENTS.md / project.profile.yaml / docs/templates/spec.md` を貼るか、リポジトリ状態が分かる形で共有して。



---
Powered by [ChatGPT Exporter](https://www.chatgptexporter.com)