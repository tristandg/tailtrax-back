class AddFromIdToPetTransfer < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_transfers, :from_id, :integer
  end
end
