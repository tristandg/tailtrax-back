class AddAcceptedToPetTransfer < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_transfers, :accepted, :boolean
  end
end
