class Notification < ApplicationRecord
  belongs_to :user

  validates :user_id, :content, :notification_type, :presence => true
end
