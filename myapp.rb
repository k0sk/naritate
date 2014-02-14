#== ライブラリ ==#
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require 'sinatra/activerecord'

#== データベース環境設定 ==#
# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

#== 定数 ==#
# 一覧表示するレコードの件数
MAX_TITLES = 18

# ランキング表示するレコードの件数
MAX_RANK = 5

#== Web ==#
# トップ画面
get '/' do
  @page_title = '旧作チェッカー『なりたてQ作』'

  erb :index
end

# 洋画タイトル一覧
get '/foreign' do
  @page_title = '洋画 - 旧作チェッカー『なりたてQ作』'
  @fr_latest = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :foreign
end

# 邦画タイトル一覧
get '/japanese' do
  @page_title = '邦画 - 旧作チェッカー『なりたてQ作』'
  @jp_latest = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :japanese
end

# 人気タイトル
get '/hot' do
  @page_title = '人気 - 旧作チェッカー『なりたてQ作』'
  @fr_latest = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  @jp_latest = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :hot
end

#== API ==#
# 洋画タイトル一覧
get '/foreign.json' do
  content_type :json, :charset => 'utf-8'
  titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  titles.to_json(:root => false)
end

# 邦画タイトル一覧
get '/japanese.json' do
  content_type :json, :charset => 'utf-8'
  titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a
  titles.to_json(:root => false)
end

#== 投票機能 ==#
# スキ！
# 洋画タイトルの投票処理
post '/fav/fr' do
  title = Foreigntitle.find(params[:id])
  title.favs += 1
  title.save
end

# 邦画タイトルの投票処理
post '/fav/jp' do
  title = Japanesetitle.find(params[:id])
  title.favs += 1
  title.save
end

# うーん
# 洋画タイトルの投票処理
post '/boo/fr' do
  title = Foreigntitle.find(params[:id])
  title.boos += 1
  title.save
end

# 邦画タイトルの投票処理
post '/boo/jp' do
  title = Japanesetitle.find(params[:id])
  title.boos += 1
  title.save
end