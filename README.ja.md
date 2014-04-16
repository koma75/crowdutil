crowdutil
========================================================================

About
------------------------------------------------------------------------

crowdutil は Atlassian CROWD のユーザーおよびグループ管理をするための
コマンドラインツールです。

利用方法
------------------------------------------------------------------------

### インストール

~~~Shell
npm install crowdutil
~~~

又は、githubから直接

~~~Shell
npm install https://github.com/koma75/crowdutil.git
~~~

### 初期セットアップ

ツールを利用するためにはまず設定ファイルを作成する必要があります。
設定ファイルの名前は「crowdutil.json」で、コマンドラインツールを実行した
作業ディレクトリに存在しなければなりません。サンプルのcrowdutil.json 
ファイルは `crowdutil create-config -o crowdutil.json` で生成可能です。

#### CROWD setup

CROWDに接続するためには、設定対象のディレクトリ毎にCROWDアプリケーションを
登録し、crowdutilを実行するマシンのIPアドレスかホスト名を事前に登録しておく
必要があります。

設定方法の詳細については [Atlassian Crowd Documentation (Adding an Application)](https://confluence.atlassian.com/display/CROWD/Adding+an+Application#AddinganApplication-add) を参照してください。

1. CROWDに管理者ユーザーでログイン
2. Applicationメニューを選択
3. 設定を行う対象のディレクトリ毎にアプリケーションを作成
    1. Details
        * Generic Application を選択
        * 名前を入力（crowdutil.jsonファイルで対象を指定する際に利用します）
        * パスワードを入力
    2. Connection
        * URL はcrowdutilを利用するマシンのホスト名を入力
    3. Directories
        * このアプリケーションに関連付けるディレクトリを選択（１つのみ）
    4. Authentication
        * 空欄
    5. Confirmation
        * 内容確認し作成
4. Search Applications に移動し、作成したアプリケーションを選択 
5. Remote Addresses タブを選択
6. crowdutilを利用するマシンのIPアドレス又はホスト名を全て追加
7. 3から6のステップを操作対象のディレクトリ毎に繰り返し実施

#### crowdutil.json

crowdutil.json ファイルにはツールの設定を記述します。crowdutilはコマンドを
実行した作業ディレクトリ内にある crowdutil.json ファイルを自動で読み込み
利用します。

設定ファイルはJSONファイルで以下のキーが記載されます
the setting file is a hash table in the following format:

* "directories" キー以下に利用するCrowdのディレクトリ毎の接続設定情報が
  格納されます
    * この中のkey-valueペアのkeyはcrowdutilコマンドで利用するディレクトリ指定
      のための名前を記載します
    * この中のkey-valueペアのvalueには[atlassian-crowd npm](https://www.npmjs.org/package/atlassian-crowd) で利用するCROWDのアプリケーション接続設定を
      記載します。
        * この中にある application name は、CROWDで作成したアプリケーション
          の名前を入力します。
* "defaultDirectory" キーにはデフォルトで利用するディレクトリのキーを
  入力します（上記directories内にあるkeyのどれか一つを入力）。
    * -Dコマンドオプションを省略した場合、この値で指定されたディレクトリ
      が利用されます。
* "logConfig" キーには[log4js](https://www.npmjs.org/package/log4js)で利用する
  設定を入力してください。
    * 省略可能。
    * appendersの値は必ず "crowdutil" とすること

#### crowdutil.json のサンプル

~~~JSON
{
  "directories": {
    "test": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "test application",
        "password": "pass123"
      }
    },
    "sample1": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "sample application 1",
        "password": "pass123"
      }
    }
  },
  "defaultDirectory": "test",
  "logConfig": {
    "appenders": [
      {
        "type": "file",
        "filename": "./crowdutil.log",
        "maxLogSize": "204800",
        "backups": 2,
        "category": "crowdutil"
      },
      {
        "type": "console",
        "category": "crowdutil"
      }
    ],
    "replaceConsole": true
  }
}
~~~

### create-user

対象ディレクトリにユーザーを作成

~~~Shell
crowdutil create-user -D directory -f firstname -l lastname -d dispname \
  -e user@example.com -u username -p password
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -f, --first
    * ユーザーの名前
* -l, --last
    * ユーザーの苗字
* -d, --dispname
    * ユーザーの表示名
    * 省略可能: 省略時は first last になります
* -e, --email
    * ユーザーのe-mailアドレス
* -u, --uid
    * ユーザーID
* -p, --pass
    * ユーザーのパスワード
    * 省略可能: 省略時はランダム生成の文字列になります。

### create-group

対象ディレクトリにグループを作成

~~~Shell
crowdutil create-group -D directory -n groupname -d "group description"
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -n, --name
    * グループ名
* -d, --desc
    * グループの説明文
    * 省略可能

### add-to-groups

複数のユーザーを複数のグループに一斉追加。全ユーザーはそれぞれ全グループに
追加されます。

~~~Shell
crowdutil add-to-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -g, --group
    * カンマ区切りのグループ名のリスト
* -u, --uid
    * カンマ区切りのuidのリスト

### rm-from-groups

複数のユーザーを複数のグループから一斉削除。全ユーザーは全グループから
削除されます（直接メンバのみ）

~~~Shell
crowdutil rm-from-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -g, --group
    * カンマ区切りのグループ名のリスト
* -u, --uid
    * カンマ区切りのuidのリスト

### empty-groups

指定したグループの直接メンバーを全て削除

~~~Shell
crowdutil empty-groups -D directory -g group1,group2,group3
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -g, --group
    * カンマ区切りのグループ名のリスト
    * comma separated list of group names to empty users of
* -f, --force
    * 確認せずに実施します
    * 省略可能: 省略時は削除の前に確認されます。
        * 確認された場合は "yes" と入力することで実行されます

### batch-exec

CSV（カンマ区切り）ファイルベースのバッチファイルを入力し、バッチ処理を実施

~~~Shell
crowdutil batch-exec -D directory -b path/to/batchfile.csv
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -b, --batch
    * バッチファイルのファイルへのパス
    * path to batch file.
* -f, --force
    * バッチ内のコマンドにエラーがあっても処理を継続します
    * 省略可能: 省略時はバッチ内のコマンドのエラーを検知した場合、
      以降のバッチ内コマンドの発行を停止し、終了します。

#### batchfile format

バッチファイルの形式は [Jglr](https://www.npmjs.org/package/jglr) の
フォーマットに準拠します。

以下のコマンドが利用可能です：

* create-user
    * ユーザーを作成
    * params: directory,first,last,disp,email,uid,pass
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * first: first name
        * last: last name
        * disp: display name (optional)
        * email: email address
        * uid: user ID
        * pass: password (optional)
* create-group
    * グループを作成
    * params: directory,name,desc
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * name
        * desc
* add-to-group
    * ユーザーをグループに追加
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * user
        * groupname
* rm-from-group
    * ユーザーをグループから削除
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * user
        * groupname
* empty-group
    * グループから全てのユーザーを削除
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * groupname
* deactivate-user [未実装]
    * ユーザーを非アクティブ化
    * params: directory,uid,rmfromgroupFlag
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * uid
        * rmfromgroupFlag
            * if rmfromgroupFlag is set to 1 or true, the user will be 
              removed from all groups.
* remove-group
    * グループを削除
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * groupname
* seq
    * この行以前のコマンドが終了するのを待ち、以降のコマンドは1行ずつ
      シーケンシャルに実行
* par
    * この行以前のコマンドが終了するのを待ち、以降のコマンドは並列で
      複数実行（デフォルトは１０並列）
    * params: numParallel
        * numParallel (optional)
            * 並列実行するコマンド最大数を指定。
            * 注意： CROWDが受付可能な接続すうやバックエンドのDBの接続
              数上限を超えた場合、コマンドが失敗する可能性があります
* wait
    * この行以前のコマンドが終了するのを待ちます

各バッチファイル内のコマンドのパラメータはオプショナルな場合でもスキップは
できません。又、コマンドの仕様より超過する余剰のパラメータは全て無視されます。

不正な例:

~~~
create-user,john,doe,joed@example.com,joed
~~~

正常な例:

~~~
create-user,,john,doe,,joed@example.com,joed
           ^         ^                      ^
           スキップは出来ません.       最後のオプションは省略可能
empty-group,,groupname,foo,bar,baz,,,
           ^          ^ ここから以降の余剰パラメータは無視
           スキップは出来ません。
~~~

### test-connect

対象ディレクトリへの接続テストを実施

~~~Shell
crowdutil test-connect -D directory
~~~

* -D, --directory
    * 設定を実施するディレクトリ。crowdutil.jsonファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能： 省略した場合は crowdutil.json ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります

### create-config

サンプルの設定ファイルを生成

~~~Shell
crowdutil create-config -o sample.json
~~~

* -o, --out
    * 出力ファイル名。デフォルトは crowdutil.jsonになります
    * stdout と設定することで標準出力に出力します。
* -f, --force
    * このフラグを設定した場合、ファイルを上書きします。指定しない場合は
      同名のファイルが有る場合は上書きしません。

Known issues & Bugs
------------------------------------------------------------------------

* ひと通り動作確認はしていますが、現状テスト不十分です。

Change History
------------------------------------------------------------------------

Date        | Version   | Changes
:--         | --:       | :--
2014.04.15  | 0.4.0     | added batch-exec command
            |           | added create-config command
            |           | fixed a few README documentation errors
2014.04.02  | 0.3.2     | fixed --help command
            |           | fixed vague command options ("-n, --name")
            |           | fixed debug logging of Objects
            |           | fixed command name of test-connection to test-connect, to fit inside the help
2014.04.02  | 0.3.0     | logging feature implemented using log4js
            |           | added --verbose mode.
2014.03.28  | 0.2.1     | documentation fix.
2014.03.28  | 0.2.0     | parameter check implemented.
            |           | some command line options changed to optional
            |           | default directory option added
            |           | Fixed program execution path.
2014.03.24  | 0.1.0     | First Release

License
------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2014 Yasuhiro Okuno

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

### documents

This readme file by Yasuhiro Okuno is licensed under CC-BY 3.0 international
license.
