class CreatePetHealthRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :pet_health_records do |t|
      t.string :condition_notes
      t.integer :severity_override
      t.integer :vet_id
      t.integer :user_id

      t.timestamps
    end
  end
end
