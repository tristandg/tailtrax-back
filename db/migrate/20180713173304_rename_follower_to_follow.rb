class RenameFollowerToFollow < ActiveRecord::Migration[5.1]
  def change
    rename_table :followers, :follows
  end
end
