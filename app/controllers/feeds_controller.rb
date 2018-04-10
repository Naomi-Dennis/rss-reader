class FeedsController < ApplicationController


    get '/edit_feeds' do
      @current_user = User.getLoggedUser(session[:id])
      if !@current_user.nil?
        @feeds = @current_user.feeds ;
        erb :edit_feeds
      else
        flash[:message] = "You are not logged in."
        redirect '/login'
      end
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
        @current_user.feeds.empty? ? @articles = [] : @articles = @current_feed.articles;
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
        @current_user.save!
        redirect '/edit_feeds'
      end

      patch '/add_feed' do
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
         redirect "/edit_feeds"
      end

end
