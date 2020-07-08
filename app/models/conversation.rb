class Conversation < ApplicationRecord
  has_many :messages
  has_many :participants
  has_many :users, :through => :participants

  attr_accessor :current_user
  
  def unread_messages
    current_user.unread_messages.select { |unread_message| self.messages.include? unread_message }
  end

  def unread_messages_count
    unread_messages.length
  end

  def destroy_unread_message_status
    un_messages = unread_messages
    user_unread_messages = current_user.user_unread_messages.select { |uum| un_messages.include? uum.message }
    user_unread_messages.each {|umm| umm.destroy }
  end

end
