class Api::V1::NewsSourcesController < ApplicationController

  def index
    render :json => NewsSource.all.as_json(:except => [:created_at, :updated_at]), :status => :ok
  end

  def show
    posts = Post.get_source_posts(params[:id])
    render :json => Post.serialized_posts(posts), :status => :ok
  end

end
