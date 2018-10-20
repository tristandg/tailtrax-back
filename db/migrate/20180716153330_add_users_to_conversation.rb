class AddUsersToConversation < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :user_one_id, :integer
    add_column :conversations, :user_two_id, :integer
  end
end
