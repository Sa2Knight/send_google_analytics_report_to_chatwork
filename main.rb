require_relative './analytics'
require_relative './chatwork'

BASE_URL = 'http://qs.nndo.jp'
VIEW_ID = '158527891'
CHATWORK_API_KEY = ENV['CHATWORKAPI']
CHATWORK_ROOM_ID = '59255776'

# ページ別ユーザ数をGoogleアナリティクスから取得
analitics = Analytics.new(base_url: BASE_URL, view_id: VIEW_ID)
report = analitics.report_users_count_by_date('today')

# 結果を整形してチャットワークに通知
chatwork = Chatwork.new(CHATWORK_API_KEY)
room_id  = CHATWORK_ROOM_ID
chatwork.sendMessage(room_id, <<EOS
累計 #{report[:total]}
#{report[:pages].map {|page| "#{page[:views]}: #{page[:url]}"}.join("\n")}
EOS
)

