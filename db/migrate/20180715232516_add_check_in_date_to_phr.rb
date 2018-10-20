class AddCheckInDateToPhr < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_health_records, :check_in_date, :date
  end
end
