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
- 動くやつ
  - xxxx
---

# その他先週話題に上がった奴

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

![bg](test.png)

