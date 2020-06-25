class Api::V1::PostsController < ApplicationController
  # before_action :authenticate, only: [:index]

  def index
    if current_user
      Post.get_posts_for_user(current_user)
    end
  end
end
