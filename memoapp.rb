# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'yaml'

def connection
  db_settings = YAML.load(File.read('database.yml'))[ENV['RACK_ENV']]
  PG.connect(
    host: db_settings['db_host'],
    port: db_settings['db_port'],
    user: db_settings['db_user'],
    password: db_settings['db_password'],
    dbname: db_settings['db_name']
  )
end

def retrieve_all_memos
  connection.exec('SELECT * FROM memos ORDER BY created_at DESC')
end

def retrieve_memo(id)
  result = connection.exec_params('SELECT * FROM memos WHERE id = $1', [id])
  return nil if result.num_tuples.zero?

  memo_data = result[0]
  { 'id' => memo_data['id'], 'title' => memo_data['title'], 'content' => memo_data['content'] }
end

def create_memo(title, content)
  id = connection.exec('SELECT nextval(\'memos_id_seq\')').getvalue(0, 0)
  connection.exec_params('INSERT INTO memos (id, title, content) VALUES ($1, $2, $3)', [id, title, content])
end

def edit_memo(title, content, id)
  connection.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
end

def delete_memo(id)
  connection.exec_params('DELETE FROM memos WHERE id = $1', [id])
end

get '/' do
  redirect '/memos'
end

get '/memos/new' do
  erb :new_entry
end

get '/memos' do
  @memos = retrieve_all_memos
  erb :index
end

get '/memos/:id' do
  @memo = retrieve_memo(params[:id])

  if @memo
    erb :detail
  else
    status 404
  end
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  create_memo(title, content)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = retrieve_memo(params[:id])
  erb :edit if @memo
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  edit_memo(title, content, params[:id].to_i)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  'Page not found!'
end
