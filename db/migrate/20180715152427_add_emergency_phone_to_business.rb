class AddEmergencyPhoneToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :emergency_phone, :string
  end
end
