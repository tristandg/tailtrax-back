class AddPostIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :post_id, :integer
    add_column :notifications, :group_id, :integer
    add_column :notifications, :is_read, :boolean
  end
end
