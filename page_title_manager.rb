require 'open-uri'
require 'nokogiri'
require 'json'

class PageTitleManager

  TITLES_FILE_PATH = 'titles.json'

  #
  # イニシャライザ
  #
  def initialize
    @titles =File.open(TITLES_FILE_PATH) { |f| JSON.load(f) }
  end

  #
  # URLを指定してそのページのタイトルを取得する
  # 一度取得したタイトルはキャッシュする
  # @param  [String] url 対象ページのURL
  # @return [String] ページタイトル
  #
  def get_or_fetch(url)
    return @titles[url] if @titles[url]
    @titles[url] = page_title_by(url: url)
  end

  #
  # @titlesをJSONファイルにシリアライズする
  #
  def save
    File.open(TITLES_FILE_PATH, 'w') do |f|
      f.puts JSON.pretty_generate(@titles)
    end
  end

  private

    #
    # WebページのURLを指定し、対象ページのタイトルを取得する
    # @param  [String] url 対象ページのURL
    # @return [String] ページタイトル
    #
    def page_title_by(url:)
      p 'fetch suruyo'
      doc = Nokogiri::HTML.parse(open(url))
      doc.title.split('|').first.strip
    end

end
