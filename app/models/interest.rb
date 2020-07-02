class Interest < ApplicationRecord
  has_many :user_interests
  has_many :users, :through => :user_interests

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
