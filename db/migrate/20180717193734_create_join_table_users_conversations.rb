class CreateJoinTableUsersConversations < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :conversations do |t|

    end
  end
end
