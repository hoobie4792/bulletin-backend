class RemoveReadFromMessages < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :read
  end
end
