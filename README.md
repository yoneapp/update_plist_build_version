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

    $ export INFO_PLIST_PATH=/path/to/info.plist
    $ bundle exec update_plist_build_version

or

    $ bundle exec update_plist_build_version --src_file=/path/to/info.plist --dst_file=/path/to/new_info.plist

or

    $ bundle exec update_plist_build_version --src_file=/path/to/info.plist
