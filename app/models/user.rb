require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt


  has_many :user_feed
  has_many :feeds, through: :user_feed

  def password
     password ||= Password.new(password_hash)
   end

   def password=(new_password)
     password = Password.create(new_password)
     self.password_hash = password
   end

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
