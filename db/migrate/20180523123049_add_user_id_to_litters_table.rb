class AddUserIdToLittersTable < ActiveRecord::Migration[5.1]
  def change
    add_column :litters, :user_id, :integer
  end
end
