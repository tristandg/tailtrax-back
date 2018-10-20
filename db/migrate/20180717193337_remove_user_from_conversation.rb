class RemoveUserFromConversation < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversations, :user_one_id
    remove_column :conversations, :user_two_id
  end
end


