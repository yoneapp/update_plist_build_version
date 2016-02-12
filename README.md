# UpdatePlistBuildVersion

XCodeプロジェクトに含まれる`info.plist`中のバージョン番号をインクリメントするスクリプト。

## Installation

    $ cd /path/to/update_plist_build_version
    $ bundle install (or $ bundle install --path=.bundle)
    $ bundle exec rake build
    $ sudo gem install pkg/update_plist_build_version-0.0.1.gem

## Usage

入力ファイル、出力ファイルのパスは環境変数とコマンドライン引数の両方から与えられます。
出力ファイルパスを指定しなかった場合は入力ファイルを上書きします。


### パスを環境変数で与える場合

パスを環境変数で与える場合は環境変数 `INFO_PLIST_PATH` にパスを与えた上でスクリプトをコマンドライン引数なしで実行してください。

    $ export INFO_PLIST_PATH=/path/to/info.plist
    $ bundle exec update_plist_build_version

### パスをコマンドライン引数で与える場合

読み込みファイルと書き出しファイルが同じ場合は読み込みファイルのみ指定すれば、そのファイルを上書きします。

    $ bundle exec update_plist_build_version --src_file=/path/to/info.plist

読み込みファイルと書き出しファイルが別の場合はそれぞれ個別に指定します。

    $ bundle exec update_plist_build_version --src_file=/path/to/info.plist --dst_file=/path/to/new_info.plist


### 既存のスクリプト内にimportしてライブラリとして使用する場合

既存のスクリプト内で使用する場合は下記のようにしてください。

```ruby
require "update_plist_build_version"

updater = UpdatePlistBuildVersion::Runner.new(src_file:"/path/to/info.plist")
updater.run
```

"/path/to/info.plist" の部分は実際のファイルの相対パスまたは絶対パスを指定してください。
インクリメント処理はrunメソッドを実行した時点で行われます。

もしも読み込みファイルと書き出しファイルが異なる場合は以下のように書き出しファイルを指定してください。
最初の例のように書き出しファイルのパスを指定しなかった場合は元のファイルを上書きします。

```ruby
require "update_plist_build_version"

updater = UpdatePlistBuildVersion::Runner.new(src_file:"/path/to/info.plist", dst_file:"/path/to/info2.plist")
updater.run
```

環境変数で指定した上で既存のスクリプト内で使用する場合は、上記のファイルパス指定の部分を環境変数からとってくるようにします。
例として環境変数 `INFO_PLIST_PATH` で `info.plist` へのパスを指定する場合は、

スクリプト実行前に環境変数を設定

    $ export INFO_PLIST_PATH=/path/to/info.plist

そして、下記のように実装し、実行します。

```ruby
require "update_plist_build_version"

updater = UpdatePlistBuildVersion::Runner.new(src_file:ENV["INFO_PLIST_PATH"])
updater.run
```

## Fastlaneと一緒に使う

```ruby
platform :ios do

  lane :adhoc do
    UpdatePlistBuildVersion::Runner.new(src_file: "../YourProject/Info.plist").run
    sigh(adhoc: true)

    gym()
    deploygate()
    crashlytics()
  end

end
```
