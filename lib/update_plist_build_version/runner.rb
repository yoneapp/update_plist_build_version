# -*- coding: utf-8 -*-
require "rexml/document"

module UpdatePlistBuildVersion
  class Runner

    attr_accessor :src_path, :dst_path, :today

    def initialize(opts)
      @src_path = opts[:src_file] || (raise ArgumentError.new("Source file path required!"))
      check_src_file(@src_path)
      @dst_path = opts[:dst_file] || @src_path
      @xml = REXML::Document.new(File.open(@src_path))
      @today = Time.now
    end

    ###
    # バージョンのインクリメント処理を開始します.
    def run
      pos = get_version_position(@xml)
      version = @xml.elements["plist/dict/string[#{pos}]"].text
      date,index =  version.split(/\./)

      next_version = if today?(date)
                       "#{date}.#{index.to_i + 1}"
                     else
                       "#{today_str}.0"
                     end
      
      @xml.elements["plist/dict/string[#{pos}]"].text = next_version
      write(@xml)
      return next_version, @xml
    end

    private

    ###
    # XML中でのバージョン番号の位置を返します。
    # 存在しなければArgumentErrorをraiseします。
    def get_version_position(xml)
      pos = 0

      xml.elements["plist/dict"].each do |dict|
        if dict.class == REXML::Element and dict.name == "key"
          pos += 1
          return pos if dict.text == "CFBundleVersion"
        end
      end

      raise ArgumentError.new("CFBundleVersion not found.")
    end

    ###
    # 本日を示す文字列を返します。
    def today_str
      @today.strftime("%Y%m%d")
    end

    ###
    # info.plist中のバージョンに含まれる日付が本日ならtrueを返します。
    def today?(date_str)
      @today.strftime("%Y%m%d") == date_str
    end

    ###
    # 指定の出力先ファイルへ書き出します。
    # XMLの正しさには関係ありませんが、<plist 前に改行入れるのと
    # シングルクォーテーションをダブルクォーテーションに置き換えて、元のファイルに合わせておきます。
    def write(xml)
      File.open(@dst_path, "w") do |f|
        f.write(xml.to_s.sub(/\<plist/, "\n<plist").gsub(/\'/, "\""))
      end
    end

    ###
    # info.plistが指定の位置に存在しなければArgumentErrorをraiseします。
    def check_src_file(src_path)
      unless File.exist?(src_path)
        raise ArgumentError.new("XML file not exist: #{src_path}")
      end
    end

  end
end
