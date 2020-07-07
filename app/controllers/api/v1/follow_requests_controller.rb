class Api::V1::FollowRequestsController < ApplicationController

  before_action :authenticate, :only => [:create, :accept_request, :deny_request]

  def create
    if current_user
      followed_user = User.find_by(username: follow_request_params[:followed])
      follow = Follow.find_by(follower: current_user, followed: followed_user)
      if follow
        if follow.destroy
          render :json => { result: 'follow' }, :status => :ok
        else
          render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
        end
      else
        follow_request = FollowRequest.find_by(follower: current_user, followed: followed_user)
        if follow_request
          if follow_request.destroy
            Notification.where(user: followed_user, content: "#{current_user.username} has requested to follow you").destroy_all
            render :json => { result: 'follow' }
          end
        else
          if followed_user.is_private
            follow_request = FollowRequest.new(follower: current_user, followed: followed_user)
            if follow_request.save
              Notification.create(user: followed_user, content: "#{current_user.username} has requested to follow you", notification_type: 'follow request')
              render :json => { result: 'pending request' }, :status => :ok
            else
              render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
            end
          else
            follow = Follow.new(follower: current_user, followed: followed_user)
            if follow.save
              render :json => { result: 'unfollow' }, :status => :ok
            else
              render :json => { message: follow.errors.full_messages.join(', ') }, :status => :bad_request
            end
          end
        end
      end
    else
      render :json => { message: 'Must be logged in to follow user' }, :status => :unauthorized
    end
  end

  def accept_request
    if current_user
      follow_request = FollowRequest.find_by(followed: current_user, follower: User.find_by(username: follow_request_params[:follower]))
      follow = Follow.new(followed: current_user, follower: User.find_by(username: follow_request_params[:follower]))
      if follow.save
        follow_request.destroy
        Notification.where(user: current_user, content: "#{follow_request_params[:follower]} has requested to follow you").destroy_all
        render :json => { notification_content: "#{follow_request_params[:follower]} has requested to follow you" }, :status => :ok
      else
        render :json => { message: follow_request.errors.full_messages.join(', ') }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to accept request' }, :status => :unauthorized
    end
  end

  def deny_request
    if current_user
      follow_request = FollowRequest.find_by(followed: current_user, follower: User.find_by(username: follow_request_params[:follower]))
      if follow_request.destroy
        Notification.where(user: current_user, content: "#{follow_request_params[:follower]} has requested to follow you").destroy_all
        render :json => { notification_content: "#{follow_request_params[:follower]} has requested to follow you" }, :status => :ok
      else
        render :json => { message: follow_request.errors.full_messages.join(', ') }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to deny request' }, :status => :unauthorized
    end
  end

  private

  def follow_request_params
    params.require(:follow_request).permit(:followed, :follower)
  end

end
