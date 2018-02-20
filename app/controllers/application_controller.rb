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
      erb :index
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
      @current_user.updateFeeds
      @feeds = @current_user.feeds
      @articles = []
      @feeds.each do | feed |
        item = {:name => feed.name, :articles => [feed.articles[0], feed.articles[1] ] }
        @articles << item
      end
      erb :view_feeds
    else
      flash[:message] = "You are not logged in."
      redirect '/login'
    end
  end

  get '/delete_feed' do
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
        @feeds = @current_user.feeds
        erb :remove_feed
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
    added_user_feed = Feed.find_by(url: url)
    if added_user_feed.nil?
      added_user_feed = Feed.create(url: url)
      added_user_feed.articles << added_user_feed.parse_articles
    else
        added_user_feed.updateFeed
     end
    added_user_feed.save
    user = User.find_by(id: session[:id])
     if !user.feeds.include?(added_user_feed)
       user.feeds << added_user_feed
        user.save
     else
       flash[:message] = "#{added_user_feed.name} is already in your feeds."
     end
    redirect '/feeds'
  end

  post '/remove_feeds' do
    feeds = params["selected_feeds"]
    @current_user = User.getLoggedUser(session[:id])
    @current_user.feeds = @current_user.feeds.reject do | feed |
      feeds.include?(feed.id.to_s)
    end
    binding.pry
    redirect '/feeds'
  end

end
