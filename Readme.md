# Readme

## 概要

docker-composeでRails6プロジェクトを作ってみた ^ ^

- 2019/12/20 一部手順を修正。
- 2020/04/03 コンテナにOracle-instantcliantを追加し、ruby-oci8でのdbコネクションを実現
- 2020/06/02 docker-compose.ymlでmariadbのtagを10.4に指定。
- 2020/10/12 Rubyバージョンを2.7.2に,rails versionを6.0.3に変更。gem tiny_tdsをネイティブインストール
- 2021/04/02 Railsライセンス系の問題で、ActiveStorageの依存するMimeType判定処理の更改に伴うFW更新。

## MW構成

- ruby 2.7.2
- Rails 6.0.3.6
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


