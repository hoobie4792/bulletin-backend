class Api::V1::MessagesController < ApplicationController

  before_action :authenticate, :only => [:create]

  def create
    if current_user
      message = Message.new(message_params)
      message.user = current_user
      if message.save
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
