# Readme

## 概要

今年45のオッさんがめちゃくちゃ苦しみながら、docker-composeでRails6プロジェクトを作ってみた ^ ^
    - 2019/12/20 一部手順を修正。

## MW構成

- ruby 2.6.5
- Rails 6.0.1
- MariaDB-1:10.3.15
- nodejs v10.17.0

### 初期設定

- 最初にrails用のコンテナを自前ビルドして、rails newコマンドとかDBコネクトとかを一通り設定してからdocker-composeコマンドでMariaDB連携とかをやってます。
  - 理由：railsコマンドが吐いたエラーメッセージ等をdockerコンテナの外側からチェックする方法がわからんので、一旦まともに動くimageにしてから連携した(dockerのスキル不足が原因)
  - 以下、実行コマンド等の処理を記載。ほな行くで〜

1. このプロジェクトを任意のディレクトリにclone dirnameは任意のディレクトリ名に。。
    - `git clone https://gitlab.sky.ft.nttcloud.net/CS_FALCON/rails6_starter-pack.git [dirname] && cd [dirname]`
1. DockerFileをbuildします。ここではイメージ名称を「autonomation/rails」としてます。
    - `docker build -t autonomation/rails .`

+ 課題：*イメージからのビルドは手間がかかるのでここまで作成したイメージをdockerHubに上げて取得する方式に変更要。*

1. docker-cponmpse.ymlの編集。=> [password]を任意の文字列に変更（２箇所）
1. 上記コマンドが通ったらいろいろ準備完了。コンテナ起動コマンド実行。
    - `docker-compose create`
1. んで、無事に起動するとrailsコンテナとmariadbコンテナが作成されている事を下記のコマンドで確認。
    - `docker ps -a`
1. んで、コンテナをバックグラウンド起動。（docker-composeコマンドの詳細オプションは別途調べてください）
    - `docker-compse up -d`
1. 無事に起動するとカレントディレクトリにrails_dataディレクトリと、mariadb_dataディレクトリが作成されます。=>特にmariadb_dataは初期状態でmariadbのデータファイルが格納されるので一旦ls等で確認。
1. rails_dataディレクトリに遷移し、sandboxプロジェクトをGitlabからクローンします。
    - `git clone https://gitlab.sky.ft.nttcloud.net/CS_FALCON/rails6_sandbox.git sandbox`
1. 以下、railsコンテナでの作業です。下記railsコンテナ実行コマンド後はコンテナ内でのみ通るコマンドの実行となります。
    - `docker exec -it rails /bin/bash`

    1. 先ほどcloneしたsandboxディレクトリに遷移します。
        - `cd sandbox`
    1. クローンしたプロジェクトを利用する為にパッケージ取得コマンドを実行します。
        - `bundle iunstall`
    1. 上記コマンドが通ったらMariaDBコンテナ側にプロジェクトのデータベースを追加します。
        - `rails db:create`
    1. 上記コマンドがエラーなく戻ったらDB接続をテストします。
        - `rails dbconsole`
            + 接続できなかった場合の被疑箇所：DBが出来ていないか、環境変数MARIADB_PASSが存在しないケースが多いと思われます。
        - プロンプトがmariadbになったら成功です。mysqlコマンドが通る事を確認して`exit`してください。
    1. DB接続がOKならば既に実装されているModelのテーブルを作成します。
        - `rails db:reset RAILS_ENV=development`
        - `rails db:reset RAILS_ENV=test`
    1. 準備が出来たのでrails動作確認用の簡易WebサーバであるWeblickを起動します。
        - `rails s -p 3000 -b 0.0.0.0`

1. 上記weblickが起動したら母艦（コンテナを起動しているPCを便宜的にこの表現で記載します）側のWebブラウザでlocalhost:3000/を表示してrailsコンテナ内でアプリケーションが動作している事を確認します。

1. 未確認だが、ここまで行けたらdocker-compose.yml内部の下記コメントアウトを解除すれば、毎回weblickが起動した状態で動くハズ。。。。
    - `# command: rails s -p 3000 -b '0.0.0.0'`
### 注意：
- 開発中はweblick起動コマンドやrails db:resetコマンドはかなりの回数発行するコマンドとなりますのでrailsコンテナは母艦側のコードエディタのターミナル側に常時表示する事が望ましいと思われます（スタック内容などが参照可能である為）。

以上、各自環境で動作確認＋さらなる洗練をお願い致し申す。。。
