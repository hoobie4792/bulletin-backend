class Api::V1::UserInterestsController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      UserInterest.where(user: current_user).destroy_all
      interests_params[:ids].each do |interest_id| 
        if !UserInterest.find_by(user: current_user, interest_id: interest_id)
          UserInterest.create(user: current_user, interest_id: interest_id)
        end
      end
      render :json => true
    else
      render :json => { message: 'Must be logged in to update interests' }, :status => :unauthorized
    end
  end

  private

  def interests_params
    params.require(:interest).permit(:ids => [])
  end

end
