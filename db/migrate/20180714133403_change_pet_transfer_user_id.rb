class ChangePetTransferUserId < ActiveRecord::Migration[5.1]
  def change
    change_column :pet_transfers, :user_id, :integer
  end
end
