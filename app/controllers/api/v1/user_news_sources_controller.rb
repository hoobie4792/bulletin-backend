class Api::V1::UserNewsSourcesController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      UserNewsSource.where(user: current_user).destroy_all
      news_sources_params[:ids].each do |news_source_id| 
        if !UserNewsSource.find_by(user:current_user, news_source_id: news_source_id)
          UserNewsSource.create(user: current_user, news_source_id: news_source_id)
        end
      end
      render :json => true
    else
      render :json => { message: 'Must be logged in to update sources' }, :status => :unauthorized
    end
  end

  private

  def news_sources_params
    params.require(:source).permit(:ids => [])
  end

end
