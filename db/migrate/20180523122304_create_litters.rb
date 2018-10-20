class CreateLitters < ActiveRecord::Migration[5.1]
  def change
    create_table :litters do |t|
      t.string :name
      t.string :litter_description
      t.integer :pet_mom_id
      t.integer :pet_dad_id
      t.date :birthday

      t.timestamps
    end
  end
end
