class Post < ApplicationRecord
  belongs_to :user

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

  def self.get_posts_for_user(user)
    posts = Post.all
  end

  def likes_count
    self.likes.length
  end
end
