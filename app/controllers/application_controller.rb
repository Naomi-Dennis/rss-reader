require 'sinatra'
require 'sinatra/flash'
class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash

  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions

## Get Requests
  get '/' do
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds'
    else
      erb :index
    end
  end

  get '/account' do
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      erb :account
    else
      flash[:message] = "You are not logged in."
      redirect '/login'
    end
  end

  get '/forgot_pass' do
  @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds'
    else
      erb :forgot_pass
    end
  end

  get '/login' do
  @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds'
    else
      erb :login
    end
  end

  get '/signup' do
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds'
    else
      erb :signup
    end
  end

  get '/signout' do
    session.clear
    flash[:message] = "Sucessfully logged out."
    redirect '/'
  end

  get '/feeds' do
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      erb :view_feeds
    else
      flash[:message] = "You are not logged in."
      redirect '/login'
    end
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

  post '/process_feeds' do
    url = params[:feed]
  end

end
