# MemoApp
 "MemoApp" はFBCのプラクティスで作ったシンプルなメモアプリです。
 
## 必要条件
* Mac 13.5.2
* ruby 3.2.2
* PostgreSQL 14.9
* sinatra 3.1.0

## 使い方
1. `new`を押して新規登録画面にいく。
1. タイトルと内容を入れて`go`（保存）する。
1. メモ一覧に保存したメモが表示される。
1. メモのタイトルを押すと詳細のページに遷移するので、編集したい場合は`edit`ボタンを、削除したい場合は`delete`ボタンを押して編集などを行なってください。

# インストール
`git clone`をしてください。
```bash
$ git clone https://github.com/sharoa119/Public.git
```

カレントディレクトリに移動します。
```bash
$ cd Public
```

`Public`ディレクトリに移動したら、必要なgemをインストールするために以下のコマンドを実行してください。
```bash
$ bundle install
```

次にPostgreSQLを起動しますが、
PostgreSQLをインストールしていない場合、Homebrewを使ってPostgreSQLをインストールしてください。
```bash
$ brew install postgresql
```
※Homebrewが入っていない場合は、[公式サイト](https://brew.sh/ja/)よりインストールをお願いいたします。

インストールが完了したら、PostgreSQLサーバーを起動します。
```bash
$ brew services start postgresql@14
```

起動ができたら、新しいPostgreSQLユーザーを作成します。ターミナルで以下のコマンドを実行して、新しいユーザーを作成します。
```
$ createuser --interactive --pwprompt memoapp
```
上記のコマンドを実行すると、ユーザー名`memoapp`を入力し、パスワードを設定します。併せて、スーパーユーザー権限を付与してください。（通常、開発環境ではスーパーユーザー権限を付与します。）

ユーザーが作成されたら、データベースを作成します。ターミナルで以下のコマンドを実行して新しいデータベースを作成します。
```
$ createdb memoapp -O memoapp;
```

データベース内にテーブルを作成するためにDDLファイルを使用します。

**DDL ファイル**: `memos.ddl`

ターミナルで次のコマンドを実行してください。
```bash
$ psql -U memoapp -d memoapp -a -f memos.ddl
```
これにより、データベース内に必要なテーブルとスキーマが作成されます。

`database.yml`ファイルを作成し、データベースへの接続情報を設定します。

以下のコマンドを実行して、`database.yml`ファイルを作成し、編集画面に遷移してください。
```
$ touch database.yml
$ vim database.yml
```

編集画面が開いたら、以下の内容を書き込んで保存してください。
```
development:
  db_host: localhost
  db_port: 5432
  db_user: memoapp
  db_password: [your_password]
  db_name: memoapp
```

保存できたら、以下のコマンドを打って環境変数の設定を行なってください。（一時的なものです。）
```
$ export RACK_ENV=development
```

アプリを起動します。
```
$ bundle exec ruby memoapp.rb
```
アプリが起動できましたら、 `http://localhost:4567/`にアクセスしてください。
`MemoApp`が表示されます。 

# その他
 
Windows環境では試しておりません。
 
# 作者

* sharoa
* FBC
* X : https://twitter.com/st_mt_tt_lol
 
 
"MemoApp" is Confidential.
