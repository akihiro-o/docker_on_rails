# Readme

## 概要

docker-composeでRails6プロジェクトを作ってみた ^ ^

- 2019/12/20 一部手順を修正。
- 2020/04/03 コンテナにOracle-instantcliantを追加し、ruby-oci8でのdbコネクションを実現
- 2020/05/18 非同期処理用のコンテナredis/sidekiqを追加。
- 2020/05/20 `docker for mac`でvolume同期が遅い問題への対処:developブランチにdocker-sync設定を追加。
- 2020/06/02 docker-compose.ymlでmariadbのtagを10.4に指定。
- 2020/10/12 Rubyバージョンを2.7.2に,rails versionを6.0.3に変更。gem tiny_tdsをネイティブインストール


## MW構成

- ruby 2.7.2
- Rails 6.0.3
- MariaDB-1:10.4(lastest)
- nodejs v10.17.0
- Oracle instantcliant 18.3
- Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit

## Oracle

oracleコンテナーへの接続方法
- https://hub.docker.com/r/epiclabs/docker-oracle-xe-11g/

動作確認用スクリプトをexampleディレクトリに配備。
- example/create_tbl.sql
  - usersテーブルを作成し、１レコード追加するsql
- test_com.rb
  - oci8で上記usersテーブルへのselectを発行するスクリプト。

## docker-sync

[docker-sync公式：](https://github.com/EugenMayer/docker-sync/blob/master/README.md)
- 概要：docker-for-macで母艦のディレクトリをマウントすると動作が鈍くなる件の解消方法。
- 具体的にはディスクマウントではなく、rsyncやunisonといったファイル転送の仕組みを使用してファイル系処理速度向上を図る方式に変更してくれるパッケージ。
- 若干設定にテクニカル要素が増えるので、Masterブランチではなくdevelopブランチにデプロイする。

- 以下、docker-syncを動作させる為に自宅Macに追加したネイティブアプリ。

```bash
sudo pip3 install --upgrade pip
pip3 install setuptools
gem install docker-sync
brew install eugenmayer/dockersync/unox
brew install fswatch unison rsync
```

- docker-sync利用時の起動コマンド

```bash
# 先にdocker-syncを起動。
docker-sync start
# docker-compose.ymlでコンテナ基本設定・docker-sync設定をdocker-compose-devで上書きする方式。
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```
- 停止コマンド

```bash
docker-compose down
docker-sync stop
```

- 補足
  - 母艦のマウント速度向上に成功したので、gemインストールディレクトリも母艦と共有可能となった。
    - 下記コマンドでパッケージを母艦に保存する設定を行えば、コンテナ再立ち上げ時にもgemインストール速度が向上する(逆にこれを行わない場合はメリットも薄い)。
    ```ruby
    bundle install --path vendor/bundle
    ```
  - 非同期処理用に作成したsidekiqコンテナはrailsコンテナと同じディレクトリをマウント。
  - oracle,sidekiqコンテナ等が不要な場合は下記のコマンドで個別に起動ができる。
