class Api::V1::InterestsController < ApplicationController

  def index
    render :json => Interest.all.as_json(:except => [:created_at, :updated_at]), :status => :ok
  end

  def show
    posts = Post.get_interest_posts(params[:id])
    render :json => Post.serialized_posts(posts), :status => :ok
  end

end
