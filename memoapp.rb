# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'yaml'

def connection
  return @db_connection if defined?(@db_connection) && @db_connection

  db_settings = YAML.load(File.read('database.yml'))[ENV['RACK_ENV']]
  @db_connection = PG.connect(
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
  connection.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [title, content])
end

def edit_memo(id, title, content)
  connection.exec_params('UPDATE memos SET title = $2, content = $3 WHERE id = $1', [id, title, content])
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
  edit_memo(params[:id], params[:title], params[:content])

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  'Page not found!'
end
