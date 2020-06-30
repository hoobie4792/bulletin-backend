class Api::V1::NewsSourcesController < ApplicationController

  def index
    render :json => NewsSource.all.as_json(:except => [:created_at, :updated_at]), :status => :ok
  end

end
