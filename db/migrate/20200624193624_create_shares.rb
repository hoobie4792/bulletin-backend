class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.integer :parent_post_id
      t.integer :shared_post_id

      t.timestamps
    end
  end
end
