class CreateUserUnreadMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :user_unread_messages do |t|
      t.integer :user_id
      t.integer :message_id

      t.timestamps
    end
  end
end
