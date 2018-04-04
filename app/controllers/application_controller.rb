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



end
