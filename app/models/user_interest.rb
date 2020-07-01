class UserInterest < ApplicationRecord
  belongs_to :user
  belongs_to :interest

  validates :user_id, :interest_id, :presence => true
end
