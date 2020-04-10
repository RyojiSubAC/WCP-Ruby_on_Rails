# WCP-Ruby_on_Rails
- 課題内容  
```
アプリケーションを作成してみよう：基礎編 応用編
```
## バージョン
- Ruby version
    - 2.7.0
- Ruby on Rails version
    - 6.0.2.2
- Mysql
    - 8.0

## 環境構築
```
・ 新規作成する場合はsrcディレクトリを空にした状態（masterをcloneするでも可）で「プロジェクト作成」から開始  
※ Gemfile（src外にある内容を写した状態）とGemfile.lock（空）は残す
・ 既存のソースを利用する場合は「コンテナをビルド&起動」から開始
```
- プロジェクト作成   
通常モードの場合
`docker-compose run web rails new . --force --database=mysql --skip-bundle`  
APIモードの場合
`docker-compose run web rails new . --api --force --database=mysql --skip-bundle`  
※ イメージ作成とホスト側にrailsの基盤を作ることがメインなので、コンテナがダウンしてても問題なし
- database.yml を修正  
```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root <-変更
  password: password <-変更
  host: db <-変更
```
- コンテナをビルド&起動  
`docker-compose -f docker-compose.yml build`  
`docker-compose -f docker-compose.yml up -d`  
※ 恐らくwebコンテナが落ちるので下記を実行
- Rails6からwebpackerが必要になったのでインストール  
`docker-compose run web rails webpacker:install`  
※ runで起動したコンテナは不要なので docker rm で削除しておく
- 再度、コンテナを起動  
`docker-compose -f docker-compose.yml up -d`
- MySQL V8で認証プラグイン「caching_sha2_password」をロードできないため下記で回避  
`docker-compose exec db bash`  
`mysql -uroot -ppassword`  
`ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'password';`  
`exit`
- DBを作成  
`docker-compose exec web rails db:create`   
- docker ps でコンテナが正常に起動していることを確認したら下記にアクセス  
http://localhost:3000/

※ gem系のエラーが発生してコンテナが起動しなかった場合  
- ログを確認  
`docker logs コンテナID`
- コンテナ・ネットワーク・ボリュームを停止・削除  
`docker-compose down -v`
- bundle install を実行  
`docker-compose run web bundle install`
- コンテナをビルド&再起動  
`docker-compose -f docker-compose.yml build`  
`docker-compose -f docker-compose.yml up -d`
