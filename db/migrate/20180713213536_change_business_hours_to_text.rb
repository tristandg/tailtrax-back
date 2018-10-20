class ChangeBusinessHoursToText < ActiveRecord::Migration[5.1]
  def change
    change_column :businesses, :business_hours, :text
  end
end
