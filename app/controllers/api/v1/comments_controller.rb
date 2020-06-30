class Api::V1::CommentsController < ApplicationController

  before_action :authenticate, only: [:create, :update, :destroy]

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
      comment = Comment.new(comment_params)
      comment.post = post
      comment.user = current_user
      if comment.save
        render :json => post.serialized, :status => :ok
      else
        render :json => { message: comment.errors.full_messages.join(', ') }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to create comment' }, :status => :unauthorized
    end
  end

  def update
    if current_user
      comment = Comment.find_by(id: params[:id])
      if comment.user == current_user && comment.update(comment_params)
        render :json => comment.as_json(:only => [:id, :content, :created_at]), :status => :ok
      else
        render :json => { message: 'Could not update comment' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to update comment' }, :status => :unauthorized
    end
  end

  def destroy
    if current_user
      comment = Comment.find_by(id: params[:id])
      if comment.user == current_user && comment.destroy
        render :json => true, :status => :ok
      else
        render :json => false, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to delete comment' }, :status => :unauthorized
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def post_params
    params.require(:post).permit(:id, :content, :created_at, :news_author, :news_image, :news_source, :news_title, :news_url, :is_news_story)
  end

end
