require 'open-uri'
require "net/http"
require 'rss'
class Feed < ActiveRecord::Base
  has_many :user_feed
  has_many :users, through: :user_feed

  has_many :articles



  def isTodaysFeed?
    if !articles.empty?
    feed_date = Date.rfc2822( articles[0].date )
    todays_date = Date.today
    feed_date == todays_date
  end
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
        parse_description = Nokogiri::HTML(item.description).css("body").text
        item.date = Time.now if item.date.nil?
        new_article = Article.create(title: item.title, description: parse_description , image: nil, link: item.link, date: item.date)
      new_article
    end
  end
end
