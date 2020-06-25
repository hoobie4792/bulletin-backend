class Share < ApplicationRecord
  belongs_to :parent_post, :class_name => 'Post', :foreign_key => :parent_post_id
  belongs_to :shared_post, :class_name => 'Post', :foreign_key => :shared_post_id
end
