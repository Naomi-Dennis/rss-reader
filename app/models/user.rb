class User < ActiveRecord::Base
  has_many :feeds

  def updateFeeds
    feeds.each do | feed |
      feed.updateFeed
    end
  end

  def self.isLoggedIn?(session)
    !session.nil?
  end

  def self.getLoggedUser(session)
    if isLoggedIn?(session)
      User.find_by(id: session)
    else
      nil
    end
  end
end
