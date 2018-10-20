class AddRemindersToPhr < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_health_records, :reminders, :string
  end
end
