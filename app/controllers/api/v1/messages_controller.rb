class Api::V1::MessagesController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      message = Message.new(message_params)
      message.user = current_user
      if message.save
        conversation = Conversation.find_by(id: message_params[:conversation_id])
        notified_participants = conversation.participants.select { |participant| participant.user != current_user }
        notified_users = notified_participants.map { |participant| participant.user }
        notified_users.each { |user| UserUnreadMessage.create(user: user, message: message) }
        render :json => message.as_json(:only => [:content, :created_at, :updated_at], :include => [:user => { :only => :username }]), :status => :ok
      else
        render :json => { message: 'Could not send message' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to send message' }, :status => :unauthorized
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end

end
