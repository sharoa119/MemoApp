# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'yaml'

def load_memos
  result = settings.db.exec('SELECT * FROM memos ORDER BY created_at DESC;').to_a
  settings.set :memos, result
end

def find_memo_by_id(id)
  settings.db.exec_params('SELECT * FROM memos WHERE id = $1', [id])
end

configure do
  set :public_folder, proc { File.join(root, 'static') }
  db_settings = YAML.load(File.read('database.yml'))[ENV['RACK_ENV']]
  set :db, PG.connect(
    host: db_settings['db_host'],
    port: db_settings['db_port'],
    user: db_settings['db_user'],
    password: db_settings['db_password'],
    dbname: db_settings['db_name']
  )
  load_memos
end

get '/' do
  redirect '/memos'
end

get '/memos/new' do
  erb :new_entry
end

get '/memos' do
  @memos = settings.memos
  erb :index
end

get '/memos/:id' do
  id = params[:id]
  result = find_memo_by_id(id)

  if result.num_tuples == 1
    @memo = result[0]
    erb :detail
  else
    status 404
  end
end

post '/memos' do
  max_id = settings.db.exec('SELECT max(id) FROM memos').getvalue(0, 0)
  new_id = max_id.to_i + 1

  settings.memos.clear
  load_memos

  new_memo = {
    'id' => new_id.to_s,
    'title' => params[:title],
    'content' => params[:content]
  }

  settings.memos << new_memo
  settings.db.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [new_memo['title'], new_memo['content']])

  redirect '/memos'
end

get '/memos/:id/edit' do
  id = params[:id]
  result = find_memo_by_id(id)

  if result.num_tuples.positive?
    @memo = result[0]
    erb :edit
  end
end

patch '/memos/:id' do
  id = params[:id]
  result = find_memo_by_id(id)

  if result.num_tuples == 1
    memo = result[0]
    memo['title'] = params[:title]
    memo['content'] = params[:content]

    settings.db.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [memo['title'], memo['content'], id])
  end

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]
  result = find_memo_by_id(id)

  settings.db.exec_params('DELETE FROM memos WHERE id = $1', [id]) if result.num_tuples == 1
  load_memos

  redirect '/memos'
end

not_found do
  'Page not found!'
end
