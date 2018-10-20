class AddPetIdToPhr < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_health_records, :pet_id, :integer
  end
end
