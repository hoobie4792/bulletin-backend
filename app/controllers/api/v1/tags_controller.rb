class Api::V1::TagsController < ApplicationController

  before_action :authenticate, :only => [:get_posts]

  def get_posts
    posts = []
    tags_params[:names].each do |name|
      tag = Tag.find_by(name: name.downcase)
      if tag
        posts += tag.posts
      end
    end
    if current_user
      posts = posts.uniq.select { |post| !post.user.is_private || post.user.followers.include?(current_user) }
    else
      posts = posts.uniq.select { |post| !post.user.is_private }
    end
    render :json => Post.serialized_posts(posts)
  end

  private

  def tags_params
    params.require(:tags).permit(:names => [])
  end

end
