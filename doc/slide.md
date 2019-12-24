---
marp: true
---
<!-- $theme: gaia -->
<!-- $size: 4:3 -->
<!-- page_number: true -->
<!-- paginate: true -->
# 言語選定Working -> Frontend/Backend、他
2019.12.23 支援G大塚

---

<!-- backgroundColor: aqua -->
# 前回までの言語選定Wroking

## Backend開発
- FrameWork Ruby on Rails(ruby 2.6.5,rails 6.0.1)
  - 必要ビジネスロジックの洗い出し完了までの暫定採用。
  - 半年後に見直し
## Frontend開発
- JavaScript　Framework：Vue.js
- CSS Framework: 未定：なんとなくBootstrap-Vue?

  > 但し、JS/CSSのFWは、Backend側FWに「パッケージ」として提供されている物からの選出が理想的(個別インストレーションしたくない)。

---

<!-- backgroundColor: olive -->
<!-- color: #f1f1f1 -->
# 調査結果の共有

---
<!-- backgroundColor: #f1f1f1 -->
<!-- color: pink -->
# Railsへのインストール方式

- Vue.js
  - プロジェクト作成時にJSフレームワークの指定オプションあり(対象：rails5以上)
  `rails new <<project>> --webpack=vue`
    - (実際は既定のDB指定等のOptionがもう少し必要）
- Bootstrap-Vue
  - 上記webpack指定をvueにしていればyarnで追加可能。
    `yarn add bootstrap-vue`
- 検証環境
  - [docker-comporse](https://gitlab.sky.ft.nttcloud.net/CS_FALCON/rails6_starter-pack)　当該PJ
  - [matuda謹製railsPJ](https://gitlab.sky.ft.nttcloud.net/CS_FALCON/rails6_sandbox)　*.DS_Storeの誤Upload状態
  - [Rails5だけど動くやつ](https://github.com/akihiro-o/r5app) Vue.jsとCSS-FWにmaterializeを組み込み動作中


---

# その他、先週話題に上がった奴1
- テスト方法
  - Testing Framework
    - Rspec (UT)
    - Selenium (IT)
      - 複数環境での試験(FireFox/Charome)
        - Selenium GridをTestbed側で構築
        (GitへのPush時にJenkinsで実行)
        - 但し、テストコードが記載されている事が前提条件。
  - その他、FWを使用しないPJは星取表作成の上、手動チェック。

---
# その他、先週話題に上がった奴2
- コーディング規約
  - rubocop コミュニティルール+支援Gルールを作成して適用。
    - https://kitsune.blog/rails-rubocop
- ドキュメンテーション
  - 基本的にテキストベースの仕様書はアプリケーションにdocディレクトリを作成し、そこでコードと共に差分管理。
    - UMLはVScodeの機能拡張PlantUMLをDefaultのエディタにしたい(テキストベースだから)。
    - プレゼンテーションもmarkdownで記入可能(Marp for vscode)。
      - これを使用すればプレゼンテーションも差分管理可能になるんだな。。
    - (実はERもvscodeで記入できるがまだ未検証。。）

---

# その他、先週話題に上がった奴3
- FrontEnd/Backendの分離
  - ビジネスロジック
    - 基本的にBackendで実装。
      - taskとしてサーバ側実行できる機能をWeb呼び出しで共有化。
      - 機能単位で実装。リクエスト処理はRESTfulを基本とする。
      - 画面系機能はAPIでも叩けるように設計する(API->画面)。
    - VIEW
      - 難解なCSS及びJSを都度作成せずに汎化できる物を作成する。
        - もっと言うとまずはFWのライブラリを使用。
          - で、FWのライブラリに存在しない機能要望発生->どうしても必要な場合のみ自前実装する。
---

# リソースの分離
  - CORS制約解除の恩恵を利用
    - 比ビジネスロジックの分離
      - JS/CSS/HTML系で完結するコンテンツであればWindows機側にデプロイ。
      （NodeJSは動作するので、Vue.js/SCSS系は動作すると思われる）

---

# 今週(2019/12/23)の決定項目
  - JavaScriptFW -> Vue.js で確定！（半年後に見直しを図る）
    - 決定要因
      - VDOMを使えるから。
      - 学習コストが低いから。
      - パッケージ追加が可能(RailsPJの場合、yarnに依存)
  - CSS-FW -> Bootstrap-Vue に決定。
    - 決定要因
      - 土田さんの鶴の一声->異論が出てないので確定
      - こちらも一番学習コストが低い為。
---
# (続き)
  - テストのコード化
    - 松田案：ビジネスロジックのコア部分は（重要なので）テストコードを書いても良いかも。
    - その他の声は無かった。
  ## その他の重要な決定
  - あまり活発な意見も無い上、実際に触れてみないと判定出来ないと言った意見もあったので今回で言語選定MTGは終了。