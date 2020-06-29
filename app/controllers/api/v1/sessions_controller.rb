class Api::V1::SessionsController < ApplicationController

  before_action :authenticate, :only => :get_username

  def create
    user = User.find_by(username: session_params[:username_email]) || 
      User.find_by(email: session_params[:username_email])
    if user
      if user.authenticate(session_params[:password])
        token = JWT.encode({ user_id: user.id }, ENV['SUPER_SECRET_KEY'])
        render :json => { token: token, username: user.username }, status: :ok
      else
        render :json => { message: 'Password is incorrect' }, :status => :unauthorized
      end
    else
      render :json => { message: "That email or username does not exist" }, :status => :not_found
    end
  end

  def get_username
    if current_user
      render :json => { username: current_user.username }
    else
      render :json => { message: 'No user logged in'}
    end
  end

  private

  def session_params
    params.require(:user).permit(:username_email, :password)
  end

end
