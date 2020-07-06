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

  def create
    if current_user
      conversation = Conversation.new
      if conversation.save
        Participant.create(conversation: conversation, user: current_user)
        conversation_params[:participant_usernames].each do |username|
          user = User.find_by(username: username)
          if user
            Participant.create(conversation: conversation, user: user)
          end
        end
        render :json => conversation.as_json(
          :include => [
            :participants => { :only => :id, :include => [:user => { :only => :username}] },
            :messages => { :only => [:content, :created_at, :updated_at], :include => [:user => { :only => :username }] }
          ]
        )
      else
        render :json => { message: 'Could not create conversation' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to create conversation' }, :status => :unauthorized
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:participant_usernames => [])
  end

end
