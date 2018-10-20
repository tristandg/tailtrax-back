class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :from_id
      t.integer :type
      t.string :message
      t.string :url

      t.timestamps
    end
  end
end
