class Api::V1::UserInterestsController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      interests_params[:ids].each { |interest_id| UserInterest.create(user: current_user, interest_id: interest_id) }
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
