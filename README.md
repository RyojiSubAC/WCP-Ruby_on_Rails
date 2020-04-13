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

## その他
- Bookers作成  
`rails generate scaffold Book title:string body:text`  
`rake db:migrate`  

- Rails + Selenium + DockerでSystemSpec環境構築  
```
※ rootディレクトリにいる程
$ wget -N http://chromedriver.storage.googleapis.com/81.0.4044.69/chromedriver_linux64.zip -P
$ unzip chromedriver_linux64.zip
$ rm chromedriver_linux64.zip
$ chown root:root ~/chromedriver
$ chmod 755 ~/chromedriver
$ mv ~/chromedriver /usr/bin/chromedriver
$ sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
$ sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'  
$ apt-get update && apt-get install -y google-chrome-stable
$ chromedriver -v
$ google-chrome-stable --version
```

## deviseを使用したログイン機能作成

- Gemfileを更新  
```
[Gemfile]
gem 'devise'
gem 'refile', require: 'refile/rails', github: 'manfe/refile'
gem "refile-mini_magick"

$bundle install
```  
- deviseインストール&Userモデル作成  
```
$ rails g devise:install
$ rails g devise User name:string introduction:text profile_image_id:text
$ rails g devise:views
```  
- devise設定ファイル修正  
    - 下記を追加  
    ```
    [application_controller.rb]

    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        added_attrs = [:email, :name, :password, :password_confirmation ]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs
        devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    end
    ```
    - 下記を修正  
    ```
    [devise.rb]
    # config.scoped_views = false [変更前]
    config.scoped_views = true　[変更後]
    ```
-  アクセス制限  
    - 対象ページのコンローラーに下記を追加  
    `before_action :authenticate_user!`
- 再起動不要の設定を追加  
```
[development.rb]
config.cache_classes = false
config.reload_classes_only_on_change = false
```
- ローカルサーバーを再起動  
