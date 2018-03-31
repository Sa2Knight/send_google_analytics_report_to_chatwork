require_relative './analytics'
require_relative './chatwork'
require_relative './page_title_manager'

BASE_URL = 'http://qs.nndo.jp'
VIEW_ID = '158527891'
CHATWORK_API_KEY = ENV['CHATWORKAPI']
CHATWORK_ROOM_ID = '59255776'

# ページ別ユーザ数をGoogleアナリティクスから取得
analitics = Analytics.new(base_url: BASE_URL, view_id: VIEW_ID)
report = analitics.report_users_count_by_date('today')

# 結果を整形してチャットワークに通知
chatwork = Chatwork.new(CHATWORK_API_KEY)
page_title_manager = PageTitleManager.new

today = Date.today.strftime('%Y-%m-%d')
messages = ["#{today} 累計 #{report[:total]}"]

report[:pages].each do |page|
  url = URI.escape(page[:url])
  title = page_title_manager.get_or_fetch(url)
  messages << "#{page[:views]}: #{title} #{url}"
end

page_title_manager.save
chatwork.sendMessage(CHATWORK_ROOM_ID, messages.join("\n"))
