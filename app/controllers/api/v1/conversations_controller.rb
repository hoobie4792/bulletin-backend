class Api::V1::ConversationsController < ApplicationController

  before_action :authenticate, :only => [:index, :create, :set_messages_read]

  def index
    if current_user
      rendered_conversations = []
      current_user.conversations.each do |conversation|
        conversation.current_user = current_user
        rendered_conversations << (conversation.as_json(
          :include => [
            :participants => { :only => :id, :include => [:user => { :only => :username}] },
            :messages => { :only => [:content, :created_at, :updated_at], :include => [:user => { :only => :username }] }
          ],
          :methods => [:unread_messages_count]
        ))
      end
      render :json => { 
        username: current_user.username,
        conversations: rendered_conversations
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

  def set_messages_read
    if current_user
      conversation = Conversation.find_by(id:params[:conversation_id])
      conversation.current_user = current_user
      conversation.destroy_unread_message_status
      
      updated_conversation = Conversation.find_by(id:params[:conversation_id])
      updated_conversation.current_user = current_user
      render :json => updated_conversation.as_json(
        :include => [
          :participants => { :only => :id, :include => [:user => { :only => :username}] },
          :messages => { :only => [:content, :created_at, :updated_at], :include => [:user => { :only => :username }] }
        ],
        :methods => [:unread_messages_count]
      )
    else
      render :json => { message: 'Must be logged in to update conversation' }, :status => :unauthorized
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:participant_usernames => [])
  end

end
