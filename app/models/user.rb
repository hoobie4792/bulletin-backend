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

  has_secure_password
end
