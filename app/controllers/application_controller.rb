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
    # The home page.
    # On this page, any user, including those unregistered can create a feed.
    # Only registered users will be able to save their feeds.
    @current_user = User.getLoggedUser(session[:id])
      erb :index
  end

  get '/account' do
    # Shows account details of the logged in user.
    # Note, if the user is not logged in; they won't be able to view the page and will be redirected.
    # If the user is logged in; they will only be able to view their own account details.
    # There is no way to view another's unless some vulnerability is found where a malicious person can change the
    # @current_user local variable.
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      erb :account
    else
      flash[:message] = "You are not logged in."
      redirect '/login'
    end
  end

  get '/forgot_pass' do
    # The forget password page.
    # The user will be forced to change their password.
    # DO NOT SEND THEM THEIR PASSWORD AS PLAIN TEXT!
    # This is a security vulnerability and can be exploited.
    # Always store a hash. Remmeber, Sony 2012!!!
  @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds/0'
    else
      erb :forgot_pass
    end
  end

  get '/login' do
    # The login page. If the user tries to view this page while logged in, they will be redirected to their
    # feeds page.
  @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds/0'
    else
      erb :login
    end
  end

  get '/signup' do
    # The sign up page.
    # Look for a safer way to do this. ************* DELETE
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
      redirect '/feeds/0'
    else
      erb :signup
    end
  end

  get '/signout' do
    # The sign out page.
    # Search a safer way to do this ************* DELETE
    session.clear
    flash[:message] = "Sucessfully logged out."
    redirect '/'
  end

  get '/feeds/:id' do
    # The feeds page.
    # Future update: Allow the user to view all articles in all feeds by the endless page.. functionality thing. ****** DELETE
    @current_user = User.getLoggedUser(session[:id])
    if !@current_user.nil?
     if !@current_user.feeds.empty?
      @current_user.updateFeeds
      @current_feed = Feed.find_by(id: params[:id]) if !@current_user.feeds.empty?
      @feeds = @current_user.feeds
      @articles = @current_feed.articles;
      # @feeds.each do | feed |
      #   item = {:name => feed.name, :articles => [feed.articles[0], feed.articles[1] ] }
      #   @articles << item
      # end
        erb :view_feeds
      else
        flash[:message] = "Your feed is empty!\n\nAdd a feed below!"
        redirect '/'
      end
    else
      flash[:message] = "You are not logged in."
      redirect '/login'
    end
  end

  post '/get_feed/:id' do
    redirect "/feeds/#{params[:id]}"
  end

## Post/Fetch/Delete/etc Request

  patch '/update_account' do
      new_password = params[:password]
      password = params[:confirm_password]
      email = params[:email]

      logged_user = User.find_by(email: email)

      if !logged_user.nil? && logged_user.password == password
        logged_user.email = email;
        logged_user.password = new_password if new_password != password
        logged_user.save!
        flash[:message] = "Account updated"
      else
        flash[:message] = "Password Incorrect"
       end

       redirect '/account'
  end

  post '/login' do
    logged_user = User.find_by(username: params['username'])

    if logged_user.nil? || logged_user.password != params[:password]
      flash[:message] = "Username or Password Not Found"
      redirect '/login'
    else
      session[:id] = logged_user.id
      redirect '/'
    end
  end

  post '/signup' do
    # Find ways to secure this page. ******* DELETE
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
      new_user = User.create(username: name, email:email)
      new_user.password = password;
      new_user.save!;
      session[:id] = new_user.id
      redirect '/'
    end
  end

  patch '/process_feeds' do
    # Processes feeds by saving each article as an article object and assigning it to a Feed object.
    # The feed is then assigned to the user.
    # NOTE: A user can have multiple feeds and feeds can have multiple users.
    # An article can only have ONE FEED
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
     last_feed = added_user_feed.id
    redirect "/feeds/#{last_feed}"
  end

  delete '/remove_feeds' do
    # Removes a certain feed from the user's feed list.
    feeds = params["selected_feeds"]
    @current_user = User.getLoggedUser(session[:id])
    @current_user.feeds = @current_user.feeds.reject do | feed |
      feeds.include?(feed.id.to_s)
    end
    redirect '/feeds'
  end

end
