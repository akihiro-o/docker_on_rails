# Readme

## 概要

docker-composeでRails6プロジェクトを作ってみた ^ ^

- 2019/12/20 一部手順を修正。
- 2020/04/03 コンテナにOracle-instantcliantを追加し、ruby-oci8でのdbコネクションを実現

## MW構成

- ruby 2.6.5
- Rails 6.0.2
- MariaDB-1:10.3.15
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


