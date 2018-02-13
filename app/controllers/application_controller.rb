class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions
  # use Rake::Flash

  get '/' do
    erb :index
  end

  get '/account' do
    erb :account
  end

  get '/forgot_pass' do
    erb :forgot_pass
  end

  get '/login' do
    erb :login
  end

  get '/signup' do
    erb :signup
  end

  get '/feeds' do
    erb :view_feeds
  end


end
