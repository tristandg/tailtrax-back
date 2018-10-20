class CreateJoinTableLitterPet < ActiveRecord::Migration[5.1]
  def change
    create_join_table :Litters, :Pets do |t|
      # t.index [:litter_id, :pet_id]
      # t.index [:pet_id, :litter_id]
    end
  end
end
