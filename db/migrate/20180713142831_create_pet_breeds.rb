class CreatePetBreeds < ActiveRecord::Migration[5.1]
  def change
    create_table :pet_breeds do |t|
      t.string :name

      t.timestamps
    end
  end
end