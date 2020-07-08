class Api::V1::UsersController < ApplicationController
  
  before_action :authenticate, :only => [:show, :create, :update, :destroy, :get_interests_and_news_sources, :get_badges]
  
  def show
    user = User.find_by(username: params[:id])
    if user
      if user.is_private && current_user
        if (!user.followers.include? current_user) && user != current_user
          user.current_user = current_user
          render :json => user.private_serialized, :status => :ok
          return
        end
      end
      user.current_user = current_user
      render :json => user.serialized, :status => :ok
    else
      render :json => { message: 'That user does not exist' }, :status => :not_found
    end
  end

  def create
    user = User.new(user_params)
    if user_params[:password] != user_params[:password_confirmation]
      render :json => { message: 'Passwords must match' }
    else
      if user.save
        token = JWT.encode({ user_id: user.id }, ENV['SUPER_SECRET_KEY'])
        render :json => { token: token }, :status => :ok
      else
        render :json => { message: user.errors.full_messages.join(', ')}, :status => :bad_request
      end
    end
  end

  def update
    if current_user
      user = current_user
      if user.update(username: user_params[:username], bio: user_params[:bio])
        render :json => user.serialized, :status => :ok
      else
        render :json => { message: user.errors.full_messages.join(', ') }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to update user' }, :status => :unauthorized
    end
  end

  def destroy
    if current_user
      if current_user.destroy
        render :json => true
      else
        render :json => false
      end
    else
      render :json => { message: 'Must be logged in to delete user' }
    end
  end

  def search_users
    if user_params[:username].empty?
      render :json => [].as_json, :status => :ok
    else
      render :json => User.where("username LIKE ?", "%#{user_params[:username]}%").uniq.as_json(:only => [:username]), :status => :ok
    end
  end

  def get_interests_and_news_sources
    if current_user
      render :json => { 
        interests: current_user.interests.as_json(:only => [:id, :name]), 
        news_sources: current_user.news_sources.as_json(:only => [:id, :name])
      }
    else
      render :json => { message: 'Must be logged in to get interests and news sources' }
    end
  end

  def get_badges
    if current_user
      render :json => { 
        notifications: current_user.notifications.where(read: false).length,
        messages: current_user.unread_messages.length
      }, :status => :ok
    else
      render :json => { message: 'Must be logged in to get badge counts' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :bio, :is_private)
  end

end
