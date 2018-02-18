require 'open-uri'
require "net/http"
require 'rss'
class Feed < ActiveRecord::Base
  belongs_to :user

  attr_accessor :articles

  def parse_articles
    data = open(@url)
    feed = RSS::Parser.parse(data)
    items = feed.collect do | item |
      new_item = {}
      new_item[:title] = item.title
      new_item[:description] = item.description
      new_item[:link] = item.link
      new_item[:date] = item.date
      new_item
    end
    @articles = items
  end
end
