class Post < ApplicationRecord
  belongs_to :user, :optional => true

  # Shares relationships
  has_many :parent_post_relationships, :class_name => 'Share', :foreign_key => :shared_post_id
  has_one :shared_post_relationship, :class_name => 'Share', :foreign_key => :parent_post_id
  has_many :parent_posts, :through => :parent_post_relationships, :source => :parent_post
  has_one :shared_post, :through => :shared_post_relationship, :source => :shared_post

  has_many :comments
  has_many :likes

  # Tag relationships
  has_many :post_tags
  has_many :tags, :through => :post_tags

  default_scope { order(created_at: :desc) }

  attr_accessor :current_user

  def self.get_posts_for_user(user)
    posts = []
    begin
      posts += self.get_interests_posts(user)
      posts += self.get_sources_posts(user)
      posts = posts.map { |post| Post.find_by(content: post.content) || post }
      posts = posts.uniq { |post| post.news_title }
      posts += self.get_followed_users_posts(user)
    rescue => exception
      posts += Post.all
    end
    posts.sort { |a,b| b.created_at <=> a.created_at }
  end

  def self.get_default_posts
    user = User.new()
    interest = Interest.find_by(name: 'General')
    news_source = NewsSource.find_by(name: 'USA Today')
    user.interests << interest
    user.news_sources << news_source
    self.get_posts_for_user(user)
  end

  def likes_count
    self.likes.length
  end

  def create_notifications
    self.user.followers.each do |user| 
      Notification.create(user: user, notification_type: 'post', content: "#{current_user.username} created a new post")
    end
  end

  def serialized
    self.as_json(
      :except => [:user_id, :updated_at],
      :methods => :likes_count,
      :include => [
        :user => {:only => [:username]},
        :shared_post => {
          :except => [:user_id, :updated_at],
          :include => [
          :user => {:only => [:username]}
        ]},
        :comments => {:only => [:id, :content, :created_at], 
          :include => [:user => {:only => :username}]},
        :tags => {:only => [:name]}
      ]
    )
  end

  def self.serialized_posts(posts)
    posts.as_json(
      :except => [:user_id, :updated_at],
      :methods => :likes_count,
      :include => [
        :user => {:only => [:username]},
        :shared_post => {
          :except => [:user_id, :updated_at],
          :include => [
          :user => {:only => [:username]}
        ]},
        :comments => {:only => [:id, :content, :created_at], 
          :include => [:user => {:only => :username}]}
      ]
    )
  end

  def self.get_interest_posts(interest)
    posts = []
    newsapi = News.new(ENV['NEWSAPI_KEY'])
    api_response = newsapi.get_top_headlines(category: interest, language: 'en', country: 'us')
    posts += self.map_api_response(api_response)

    saved_news_stories = Post.all.where(is_news_story: true)
    posts = posts.map do |curr_post|
      matched_news_story = saved_news_stories.find { |sns| sns.news_title == curr_post.news_title && sns.content == curr_post.content }
      if matched_news_story
        matched_news_story
      else
        curr_post
      end
    end
    
    posts
  end

  def self.get_source_posts(source)
    posts = []
    newsapi = News.new(ENV['NEWSAPI_KEY'])
    api_response = newsapi.get_top_headlines(sources: source)
    posts += self.map_api_response(api_response)

    saved_news_stories = Post.all.where(is_news_story: true)
    posts = posts.map do |curr_post|
      matched_news_story = saved_news_stories.find { |sns| sns.news_title == curr_post.news_title && sns.content == curr_post.content }
      if matched_news_story
        matched_news_story
      else
        curr_post
      end
    end

    posts
  end

  private

  def self.get_interests_posts(user)
    posts = []
    newsapi = News.new(ENV['NEWSAPI_KEY'])
    user.interests.each do |interest|
      api_response = newsapi.get_top_headlines(category: interest.name.downcase, language: 'en', country: 'us')
      posts += self.map_api_response(api_response)
    end
    posts
  end

  def self.get_sources_posts(user)
    posts = []
    newsapi = News.new(ENV['NEWSAPI_KEY'])
    user.news_sources.each do |source|
      api_response = newsapi.get_top_headlines(sources: source.name.split(' ').join('-').downcase)
      posts += self.map_api_response(api_response)
    end
    posts
  end

  def self.map_api_response(api_response)
    api_response.select { |res| !res.content.nil? }
    .map { |res| !res.content.nil? && Post.new(
      content: res.content.split(' [+').first,
      news_author: res.author,
      news_image: res.urlToImage,
      created_at: res.publishedAt,
      news_source: res.name,
      news_title: res.title,
      news_url: res.url,
      is_news_story: true) }
  end

  def self.get_followed_users_posts(user)
    posts = []
    user.followeds.each do |user| 
      posts += user.posts 
    end
    posts
  end

end
