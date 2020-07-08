class Api::V1::NotificationsController < ApplicationController

  before_action :authenticate, :only => [:index]

  def index
    if current_user
      current_user.notifications.each { |notification| notification.update(read: true) }
      notification = current_user.notifications.order('created_at desc').limit(20)
      render :json => notification.as_json(:only => [:id, :content, :notification_type, :created_at]), :status => :ok
    else
      render :json => { message: 'Must be signed in to view notifications' }, :status => :bad_request
    end
  end

end
