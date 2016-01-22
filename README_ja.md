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
設定ファイルは、コマンドラインオプションで指定する、コマンドラインツール
を実行した作業ディレクトリのcrowdutil.json、もしくは
$HOME/.crowdutil/config.json ファイルを参照します。サンプルのcrowdutil.json
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
        * 名前を入力（設定ファイルで対象を指定する際に利用します）
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

#### 設定ファイル

設定ファイルにはツールの設定を記述します。設定ファイルは --config (-c)
コマンドラインオプションで指定するか、現在の実行ディレクトリに
$PWD/crowdutil.json を置くか、$HOME/.crowdutil/config.json に置くか
することでcrowdutilに渡す必要があります。参照優先順序は前述の記述の
順序の通りとなります。

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

#### 設定ファイルのサンプル

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
      }
    ],
    "replaceConsole": false
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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

### search-user

対象のディレクトリからユーザーを検索します。
各フィールドに検索文字列を指定してください。ワイルドカード（ * ）が利用可能です。
検索は全フィールドの AND で検索されます。

~~~Shell
crowdutil search-user -D directory -f firstname -l lastname \
  -e email -u username
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -f, --first
    * 省略可能: ユーザーの名前
* -l, --last
    * 省略可能: ユーザーの苗字
* -e, --email
    * 省略可能: ユーザーのe-mailアドレス

### update-user

対象ディレクトリの指定ユーザー情報を更新する。指定のない値は変更しなません。

~~~Shell
crowdutil update-user -D directory -f firstname -l lastname -d dispname \
  -e user@example.com -u username -a [true|false]
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -f, --first
    * 省略可能: ユーザーの名前
* -l, --last
    * 省略可能: ユーザーの苗字
* -d, --dispname
    * 省略可能: ユーザーの表示名
* -e, --email
    * 省略可能: ユーザーのe-mailアドレス
* -u, --uid
    * 更新対象のユーザーID
* -a, --active
    * 省略可能: アクティブか非アクティブかの状態

### create-group

対象ディレクトリにグループを作成

~~~Shell
crowdutil create-group -D directory -n groupname -d "group description"
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -g, --group
    * カンマ区切りのグループ名のリスト
* -u, --uid
    * カンマ区切りのuidのリスト

### list-group

指定されたユーザーの所属グループを検索します。

~~~Shell
crowdutil list-group -D directory -u uid
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -u, --uid
    * 検索するユーザーID

### list-member

指定されたグループのメンバーを検索します。

~~~Shell
crowdutil list-member -D directory -g group
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります
* -g, --group
    * グループ名

### is-member

指定したユーザーが指定したグループのメンバーかどうかを確認します。

~~~Shell
crowdutil is-member -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
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
    * params: directory,uid,pass,first,last,disp,email
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * uid: user ID
        * pass: password (optional)
        * first: first name
        * last: last name
        * disp: display name (optional)
        * email: email address
* update-user
    * ユーザー情報を更新する
    * params: directory,uid,active,first,last,disp,email
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * uid: user ID to update
        * active: state of the user. [true|false], (optional)
        * first: first name (optional)
        * last: last name (optional)
        * disp: display name (optional)
        * email: email address (optional)
* create-group
    * グループを作成
    * params: directory,name,desc
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * name
        * desc
* add-to-group
    * ユーザーをグループに追加
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* is-member
    * ユーザーがグループのメンバーかどうかを確認
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* rm-from-group
    * ユーザーをグループから削除
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* empty-group
    * グループから全てのユーザーを削除
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * groupname
* remove-group
    * グループを削除
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
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
create-user,joed,john,doe,joed@example.com
~~~

正常な例:

~~~
create-user,,joed,,john,doe,,joed@example.com
           ^     ^         ^
           スキップは出来ません.
update-user,,joed,true
                      ^ 最後のオプションは省略可能
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
    * 設定を実施するディレクトリ。設定ファイルのdirectories内にある
      key のどれかと一致する必要あり。
    * 省略可能: 省略した場合は 設定 ファイルの defaultDirectory
      にて指定したディレクトリが利用されます
* -c, --config
    * 設定ファイルを指定して読み込みます
    * 省略可能: 省略した場合は $PWD/crowdutil.json, $HOME/.crowdutil/config.json
      の順でサーチして利用します。
* -v, --verbose
    * 省略可能: デバッグ出力を出力するようになります

### create-config

サンプルの設定ファイルを生成

~~~Shell
crowdutil create-config -o sample.json
~~~

* -o, --out
    * 出力ファイル名。デフォルトは $HOME/.crowdutil/config.jsonになります
        * Windows の場合は %USERPROFILE%\.crowdutil\config.json になります
    * stdout と設定することで標準出力に出力します。
* -f, --force
    * このフラグを設定した場合、ファイルを上書きします。指定しない場合は
      同名のファイルが有る場合は上書きしません。

Known issues & Bugs
------------------------------------------------------------------------

* ひと通り動作確認はしていますが、現状テスト不十分です。
* 並列実行をしている場合、以下の制約事項があります
    * 同時に実行されるバッチ部分に複数のディレクトリを指定することは出来ません（意図しないディレクトリ
      に対してコマンドが実行されてしまう可能性があります。
    * --force を使っている場合、並列実行中のコマンドがひとつエラーとなると、その他の同時実行対象の
      内、未発行のコマンドは実行されません。並列実行をする場合は--forceを利用しないことをおすすめ
      します。

Change History
------------------------------------------------------------------------

Date        | Version   | Changes
:--         | --:       | :--
2016.01.22  | 1.0.0     | Release as 1.0.  Rename README.ja.md to README_ja.md for npmjs to properly show the english readme
2015.03.23  | 0.6.3     | Fixed newline character for bin/crowdutil (from CRLF to LF)
2014.10.09  | 0.6.2     | added --config option
            |           | default config path set to $HOME/.crowdutil/config.json
            |           | changed create-config to default to $HOME/.crowdutil/config.json
2014.08.22  | 0.6.1     | added list-group command.
2014.08.22  | 0.6.0     | added STDOUT messages separately from log message for use with other cli tools
            |           | fixed error handling for asynchronous functions.
            |           | added search-user command.
            |           | added list-member command.
            |           | added is-member command/batch-command.
2014.08.16  | 0.5.3     | fixed issue with new line character
2014.07.25  | 0.5.2     | fixed issue for batch exec not using proper directory
            |           | fixed parameter check bug
2014.04.22  | 0.5.0     | added update-user command
            |           | changed the parameter ordering in the create-user batch file command to match the new update-user command.
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
