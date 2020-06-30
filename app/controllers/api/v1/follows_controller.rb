class Api::V1::FollowsController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      followed_user = User.find_by(username: follow_params[:username])
      follow = Follow.find_by(follower: current_user, followed: followed_user)
      if follow
        if follow.destroy
          render :json => false, :status => :ok
        else
          render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
        end
      else
        follow = Follow.new(follower: current_user, followed: followed_user)
        if follow.save
          render :json => true, :status => :ok
        else
          render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
        end
      end
    else
      render :json => { message: 'Must be logged in to follow user' }, :status => :unauthorized
    end
  end

  private

  def follow_params
    params.require(:follow).permit(:username)
  end

end
