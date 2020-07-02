class Api::V1::ConversationsController < ApplicationController

  before_action :authenticate, :only => [:index, :create]

  def index
    if current_user
      render :json => { 
        username: current_user.username,
        conversations: current_user.conversations.as_json(
          :include => [
            :participants => { :only => :id, :include => [:user => { :only => :username}] },
            :messages => { :only => [:content, :created_at, :updated_at], :include => [:user => { :only => :username }] }
          ]
        )
      }
    else
      render :json => { message: 'Must be logged in to view conversations' }, :status => :bad_request
    end
  end

end
