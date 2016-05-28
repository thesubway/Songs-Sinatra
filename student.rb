require 'dm-core'
require 'dm-migrations'
require './main.rb'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :bio, Text
  property :age, Integer
  property :birth_date, Date

  def birth_date=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

DataMapper.finalize
DataMapper.auto_migrate!

get '/students' do
  # does not require authorization to view students
  @students = Student.all
  erb :students
end

get '/students/new' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_student
end

post '/students' do
  halt(401, 'Not Authorized') unless session[:admin]
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
