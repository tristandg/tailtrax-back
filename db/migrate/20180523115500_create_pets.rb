class CreatePets < ActiveRecord::Migration[5.1]
  def change
    create_table :pets do |t|
      t.integer :user_id
      t.string :name
      t.integer :gender
      t.integer :weight
      t.string :pet_description
      t.string :pet_profile_pic
      t.integer :breed_id
      t.integer :color
      t.string :markings
      t.string :location
      t.string :microchip
      t.string :akc_reg_number
      t.date :akc_reg_date
      t.date :birthday

      t.timestamps
    end
  end
end
