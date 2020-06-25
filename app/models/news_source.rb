class NewsSource < ApplicationRecord
  has_many :user_news_sources
  has_many :users, :through => :user_news_sources
end
