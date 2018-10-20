class AddPostDateToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :post_date, :date
  end
end
