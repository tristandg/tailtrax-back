class ChangeFollowerIdToFollowId < ActiveRecord::Migration[5.1]
  def change
    rename_column :follows, :follower_id, :follow_id
    rename_column :follows, :follower_type, :follow_type
  end
end
