class ChangeBreedToPetBreed < ActiveRecord::Migration[5.1]
  def change
    rename_column :pets, :breed_id, :pet_breed_id
  end
end
