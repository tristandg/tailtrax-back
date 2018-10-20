class PetTransfer < ActiveRecord::Migration[5.1]
  def change
    create_table :pet_transfers do |t|
      t.integer :pet_id
      t.string :user_id
      t.timestamps
    end
  end
end
