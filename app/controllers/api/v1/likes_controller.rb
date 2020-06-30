class Api::V1::LikesController < ApplicationController

  before_action :authenticate, only: [:create, :destroy]

  def create
    if current_user
      post = Post.find_by(id: post_params[:id]) || Post.find_by(
        content: post_params[:content],
        news_author: post_params[:news_author],
        news_image: post_params[:news_image],
        news_title: post_params[:news_title]
      )
      if !post
        post = Post.new(post_params)
        if !post.save
          render :json => { message: post.errors.full_messages.join(', ')}, :status => :bad_request
          return
        end
      end
      like = Like.find_by(post: post, user: current_user)
      if like
        if like.destroy
          render :json => post.serialized, :status => :ok
        else
          render :json => { message: like.errors.full_messages.join(', ') }, :status => :bad_request
        end
      else
        like = Like.new(post: post, user: current_user)
        if like.save
          render :json => post.serialized, :status => :ok
        else
          render :json => { message: like.errors.full_messages.join(', ') }, :status => :bad_request
        end
      end
    else
      render :json => { message: 'Must be logged in to toggle like' }, :status => :unauthorized
    end
  end

  private

  def post_params
    params.require(:post).permit(:id, :content, :created_at, :news_author, :news_image, :news_source, :news_title, :news_url, :is_news_story)
  end

end
