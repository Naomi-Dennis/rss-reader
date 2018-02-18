class User < ActiveRecord::Base
  has_many :feeds
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
