class User < ActiveRecord::Base
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
