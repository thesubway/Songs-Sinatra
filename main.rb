require 'sinatra'
require 'slim'
require 'sass'
require './student'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://#{Dir.pwd}/development.db")
end

get('/styles.css'){ scss :styles }

get '/' do
  erb :home
end

get '/about' do
  @name = "All About This Website"
  erb :about
end

get '/contact' do
  erb :contact
end

not_found do
  erb :not_found
end
