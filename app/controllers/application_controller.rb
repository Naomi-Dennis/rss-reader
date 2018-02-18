require 'sinatra'
require 'sinatra/flash'
class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions
  register Sinatra::Flash


## Get Requests
  get '/' do
    @current_user = User.getLoggedUser(session[:id])
    erb :index
  end

  get '/account' do
    @current_user = User.getLoggedUser(session[:id])
    erb :account
  end

  get '/forgot_pass' do
  @current_user = User.getLoggedUser(session[:id])
    erb :forgot_pass
  end

  get '/login' do
  @current_user = User.getLoggedUser(session[:id])
    erb :login
  end

  get '/signup' do
    @current_user = User.getLoggedUser(session[:id])
    erb :signup
  end

  get '/feeds' do
  @current_user = User.getLoggedUser(session[:id])
    erb :view_feeds
  end

## Post/Fetch/Delete/etc Request

  post '/login' do
    logged_user = User.find_by(username: params['username'], password: params['password'])
    if logged_user.nil?
      flash[:message] = "Username or Password Not Found"
      redirect '/login'
    else
      session[:id] = logged_user.id
      redirect '/'
    end
  end

  post '/signup' do
    name = params[:username]
    password = params[:password]
    email = params[:email]
    if !User.find_by(email: email).nil?
      flash[:message] = "Email already registered"
      redirect '/signup'
    elsif !User.find_by(username: name).nil?
      flash[:message] = "Username taken"
      redirect '/signup'
    else
      new_user = User.create(username: name, password: password, email:email)
      session[:id] = new_user.id
      redirect '/'
    end
  end

  get '/signout' do
    session.clear
    flash[:message] = "Sucessfully logged out."
    redirect '/'
  end
end
