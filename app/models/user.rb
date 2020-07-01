class User < ApplicationRecord
  # Follower Relationships
  has_many :follows
  has_many :follower_relationships, :foreign_key => :followed_id, :class_name => 'Follow'
  has_many :followers, :through => :follower_relationships, :source => :follower
  has_many :followed_relationships, :foreign_key => :follower_id, :class_name => 'Follow'
  has_many :followeds, :through => :followed_relationships, :source => :followed
  
  # Messaging relationships
  has_many :participants
  has_many :conversations, :through => :participants
  has_many :messages

  # Notifications relationship
  has_many :notifications

  # Posts relationships
  has_many :comments
  has_many :likes
  has_many :posts
  has_many :shares

  # News sources relationships
  has_many :user_news_sources
  has_many :news_sources, :through => :user_news_sources

  #Interests relationships
  has_many :user_interests
  has_many :interests, :through => :user_interests

  has_secure_password

  attr_accessor :current_user

  validates :username, :email, :password, :presence => true
  validates :username, :email, :uniqueness => true
  validates :email, :format => { with: URI::MailTo::EMAIL_REGEXP }


  def get_user_posts
    return self.posts
  end

  def posts_count
    self.posts.length
  end

  def following
    self.followers.include? current_user
  end

  def private_serialized
    self.as_json(
      :only => [:username, :bio, :created_at],
      :methods => [:posts_count, :following],
    )
  end

  def serialized
    self.as_json(
      :only => [:username, :bio, :created_at],
      :methods => [:posts_count, :following],
      :include => [
        :posts => {:except => [:user_id, :updated_at],
          :methods => :likes_count,
          :include => [
            :user => {:only => [:username]},
            :comments => {:only => [:id, :content, :created_at], 
              :include => [user: {:only => :username}]}
          ]
        }
      ]
    )
  end

end
