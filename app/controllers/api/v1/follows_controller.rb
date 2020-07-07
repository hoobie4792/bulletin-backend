class Api::V1::FollowsController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    followed_user = User.find_by(username: follow_params[:username])
    if current_user
      follow = Follow.new(follower: current_user, followed: followed_user)
      if follow.save
        followed_user.follower_requests.where(follower: current_user).destroy_all
        render :json => true, :status => :ok
      else
        render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
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
