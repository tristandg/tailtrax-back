class ChangeRemindersToText < ActiveRecord::Migration[5.1]
  def change
    change_column :pet_health_records, :reminders, :text
  end
end
