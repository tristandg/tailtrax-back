class AddArchivedToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :archived, :boolean
  end
end
