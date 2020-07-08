class AddReasonToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :reason, :string
  end
end
