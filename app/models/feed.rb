require 'open-uri'
require "net/http"
require 'rss'
class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :articles

  def parse_articles
    data = open(url)
    feed = RSS::Parser.parse(data)
    name = feed.channel.title
    feed.channel.items.collect do | item |
      image_data = item.description.split(">")
      item.description = image_data[1]
      image_data = image_data[0] + ">"
      new_article = Article.create(title: item.title, description: item.description, image: image_data, link: item.link, date: item.date)
      new_article
    end
  end
end
