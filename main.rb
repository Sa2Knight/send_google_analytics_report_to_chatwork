require_relative './analytics'
require_relative './chatwork'

# ページ別ユーザ数をGoogleアナリティクスから取得
BASE_URL = "http://qs.nndo.jp"
view_id = '158527891'
analitics = Analytics.new(BASE_URL, view_id)
report = analitics.report_users_count_by_date('today')

# 結果を整形してチャットワークに通知
chatwork = Chatwork.new(ENV['CHATWORKAPI'])
room_id  = '59255776'
chatwork.sendMessage(room_id, <<EOS
累計 #{report[:total]}
#{report[:pages].map {|page| "#{page[:views]}: #{page[:url]}"}.join("\n")}
EOS
)

