class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions
  # use Rake::Flash

  get '/' do
    @current_user = Utility.getLoggedUser
    erb :index
  end

  get '/account' do
    @current_user = Utility.getLoggedUser
    erb :account
  end

  get '/forgot_pass' do
    @current_user = Utility.getLoggedUser
    erb :forgot_pass
  end

  get '/login' do
    @current_user = Utility.getLoggedUser
    erb :login
  end

  get '/signup' do
    @current_user = Utility.getLoggedUser
    erb :signup
  end

  get '/feeds' do
    @current_user = Utility.getLoggedUser
    erb :view_feeds
  end


end
