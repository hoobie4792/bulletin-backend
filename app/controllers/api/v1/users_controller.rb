class Api::V1::UsersController < ApplicationController
  
  before_action :authenticate, :only => [:show, :create, :update, :destroy]
  
  def show
    user = User.find_by(username: params[:id])
    if user
      if user.is_private && current_user
        if !user.followers.include? current_user
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
      if current_user.update(user_params) 
        render :json => current_user.serialized, :status => :ok
      else
        render :json => { message: 'Could not update user' }, :status => :bad_request
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

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :bio, :is_private)
  end

end
