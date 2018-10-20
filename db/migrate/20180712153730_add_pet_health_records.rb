class AddPetHealthRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :pets, :food, :string
    add_column :pets, :supplemental, :string
    add_column :pets, :health_issue, :string
    add_column :pet_health_records, :medications, :string
  end
end
