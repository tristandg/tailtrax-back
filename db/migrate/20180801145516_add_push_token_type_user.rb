class AddPushTokenTypeUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :push_token_type, :string
  end
end
