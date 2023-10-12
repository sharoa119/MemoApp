# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'yaml'

development_config = YAML.load(File.read('database.yml'))['development']

production_config = YAML.load(File.read('database.yml'))['production']

configure :development do
  set :db, PG.connect(
    host: development_config['db_host'],
    port: development_config['db_port'],
    user: development_config['db_user'],
    password: development_config['db_password'],
    dbname: development_config['db_name']
  )
end

configure :production do
  set :db, PG.connect(
    host: production_config['db_host'],
    port: production_config['db_port'],
    user: production_config['db_user'],
    password: production_config['db_password'],
    dbname: production_config['db_name']
  )
end

configure do
  set :memos, settings.db.exec('SELECT * FROM memos').to_a
end

get '/' do
  redirect '/memos'
end

get '/memos/new' do
  erb :newentry
end

get '/memos' do
  @memos = settings.memos
  erb :index
end

get '/memos/:id' do
  id = params[:id]
  memo = settings.memos.find { |m| m['id'] == id }
  if memo
    @title = memo['title']
    @content = memo['content']
    erb :detail
  else
    status 404
  end
end

post '/memos/new' do
  maxid = 0
  settings.memos.each do |m|
    id = m['id'].to_i
    maxid = id if id > maxid
  end

  new_memo = {
    'id' => (maxid + 1).to_s,
    'title' => params[:title],
    'content' => params[:content]
  }

  settings.memos << new_memo
  settings.db.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [new_memo['title'], new_memo['content']])

  redirect '/memos'
end

get '/memos/:id/edit' do
  id = params[:id]
  memo = settings.memos.find { |m| m['id'] == id }
  @title = memo['title']
  @content = memo['content']
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  memo = settings.memos.find { |m| m['id'] == id }

  if memo
    memo['title'] = params[:title]
    memo['content'] = params[:content]

    settings.db.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [memo['title'], memo['content'], id])
  end

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]
  settings.memos.reject! { |m| m['id'] == id }
  settings.db.exec_params('DELETE FROM memos WHERE id = $1', [id])

  redirect '/memos'
end

not_found do
  'Page not found!'
end
