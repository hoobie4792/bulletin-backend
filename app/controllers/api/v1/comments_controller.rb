class Api::V1::CommentsController < ApplicationController

  before_action :authenticate, only: [:create, :update, :destroy]

  def create
    if current_user
      comment = Comment.new(comment_params)
      comment.user = current_user
      if comment.save
        render :json => comment.as_json(:only => [:id, :content, :created_at]), :status => :ok
      else
        render :json => { message: 'Could not create comment' }, :status => :bad_request
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
    params.require(:comment).permit(:content, :post_id)
  end

end
