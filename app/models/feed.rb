require 'open-uri'
require "net/http"
require 'rss'
class Feed < ActiveRecord::Base
  has_many :user_feed
  has_many :users, through: :user_feed

  has_many :articles



  def isTodaysFeed?
    feed_date = Date.rfc2822( articles[0].date )
    todays_date = Date.today
    feed_date == todays_date
  end

  def updateFeed
    if !self.isTodaysFeed?
      articles.clear
      articles << self.parse_articles
    end
  end

  def parse_articles
    data = open(url)
    feed = RSS::Parser.parse(data)
    self[:name] = feed.channel.title
    feed.channel.items.collect do | item |
      if item.description.test(/<img/)
        image_data = item.description.split(">")
        item.description = image_data[1]
        image_data = image_data[0] + ">"
        image_data.insert(image_data.index('class') + 'class='.size, 'img-thumbnail')
        new_article = Article.create(title: item.title, description: item.description, image: image_data, link: item.link, date: item.date)
      else
        new_article = Article.create(title: item.title, description: item.description, image: image_data, link: item.link, date: item.date)
      end
      new_article
    end
  end
end
