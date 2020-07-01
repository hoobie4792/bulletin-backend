class UserNewsSource < ApplicationRecord
  belongs_to :user
  belongs_to :news_source

  validates :user_id, :news_source_id, :presence => true
end
