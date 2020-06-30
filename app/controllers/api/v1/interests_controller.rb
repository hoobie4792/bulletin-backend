class Api::V1::InterestsController < ApplicationController

  def index
    render :json => Interest.all.as_json(:except => [:created_at, :updated_at]), :status => :ok
  end

end
