# Readme

## 概要

今年45のオッさんがめちゃくちゃ苦しみながら、docker-composeでRails6プロジェクトを作ってみた ^ ^

## MW構成

- ruby 2.6.5
- Rails 6.0.1
- MariaDB-1:10.3.15
- nodejs v10.17.0

### 初期設定

- 最初にrails用のコンテナを自前ビルドして、rails newコマンドとかDBコネクトとかを一通り設定してからdocker-composeコマンドでMariaDB連携とかをやってます。
  - 理由：railsコマンドが吐いたエラーメッセージ等をdockerコンテナの外側からチェックする方法がわからんので、一旦まともに動くimageにしてから連携した(dockerのスキル不足が原因)
  - 以下、実行コマンド等の処理を記載。ほな行くで〜

1. このプロジェクトを任意のディレクトリにclone
    - `git clone {adrress} dirname && cd dirname`
1. DockerFileをbuildします。ここではイメージ名称を「autonomation/rails」としてます。
    - `docker build -t autonomation/rails .`
1. centos7イメージを取得したり関連パッケージを入れたりで10分強かかります。上手くビルドできたらコンテナを起動します(ここではコンテナの名前をrailsとして起動してます)。
    - `docker run -i -d --name rails -v rails_data:/var/www/myrails autonomation/rails`
1. コンテナ名「rails」の起動を`docker ps`コマンドで確認できたらコンテナのシェルに入ります。
    - `docker exec -it rails /bin/bash`
1. うまいこと言ってるならプロンプト文字が変わったハズです。`ls`コマンドでカレントディレクトリに Gemfile及び、Gemfile.lockの存在を確認したらばrailsプロジェクトを作成します。
    - `mkdir -p vendor/bundle`
    - `source /etc/profile.d/rbenv.sh; rails new . -B --database=mysql --skip-turbolinks --skip-test --skip-bundle --path vendor/bundle`
1. 続けて関連パッケージをインストールします(native側のライブラリに不都合があった場合エラーとなるので戻り値の確認要)。
    - `bundle install`
1. もろもろOKならばRailsプロジェクトが作成されているハズなので`ls`で確認。
1. ようやっと既存railsナレッジが通用するような環境なので下記コマンド実行。
    - `source /etc/profile.d/rbenv.sh; rails webpacker:install`
    - `source /etc/profile.d/rbenv.sh; rails g rspec:install`
1. 一旦コンテナを`exit`で抜けて、カレントディレクトリのrail_dataディレクトリに作成したrailsプロジェクトが存在する事を確認します。
1. 続けてdocker-compose.ymlの[password]と記載されている場所(２箇所)を任意の文字列に変更します。
1. ここからdocker-composeでコンテナ操作。まずは一旦先ほど作成したコンテナを落とす。
    - `docker-compose down`
1. で、docker-composeでrailsコンテナとmariadbコンテナを作成。
    - `docker-compose create`
1. んで、コンテナをバックグラウンド起動。（docker-composeコマンドの詳細オプションは別途調べてください）
    - `docker-compse up -d`
1. 無事起動したならばrailsからmariadbを覗きたいのでカレントディレクトリの`rails_data/config/database.yml`のdefault節に記載されているpasswordとhostを編集~保存。
    ~~~yaml
    default: &default
      adapter: mysql2
      encoding: utf8mb4
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      username: root
      password: <%= ENV['MARIADB_PASS'] %>
      host: 172.20.0.3
    ~~~
1. railsコンテナのシェルに入って、シェルからmariadbに接続できる事を確認。
    - `d exec -it rails /bin/bash`
    - んで、Mariadb接続確認（接続テストなのでOKならばexitで抜けてOK）
    - `mysql -root -p${MARIADB_PASS} -h172.20.0.3`
1. ほんで、mariadbコネクできる確証を得たのでDB作成。
    - `rails db:create`
1. 上記コマンドが通ったらいろいろ準備完了。ローカルの開発用Webサーバ起動コマンド実行。
    - `rails s -p 3000 -b 0.0.0.0`
1. これが通ったらブラウザからweblick(railsの動作確認用Webサーバ)の起動確認ができるハズなので下記URLを叩いて確認。
    - `http://localhost:3000`
1. 未確認だが、ここまで行けたらdocker-compose.yml内部の下記コメントアウトを解除すれば、毎回weblickが起動した状態で動くハズ。。。。
    - `# command: rails s -p 3000 -b '0.0.0.0'`

以上、各自環境で動作確認＋さらなる洗練をお願い致し申す。。。