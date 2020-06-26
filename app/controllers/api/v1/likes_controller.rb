class Api::V1::LikesController < ApplicationController

  before_action :authenticate, only: [:create, :destroy]

  def create
    if current_user
      like = Like.new(like_params)
      like.user = current_user
      if like.save
        render :json => like.as_json(:only => [:id, :created_at]), :status => :ok
      else
        render :json => { message: 'Could not create like' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to create like' }, :status => :unauthorized
    end
  end

  def destroy
    if current_user
      like = Like.find_by(post_id: params[:post_id], user: current_user)
      if like && like.destroy
        render :json => true, :status => :ok
      else
        render :json => false, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to delete like' }, :status => :unauthorized
    end
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end

end
