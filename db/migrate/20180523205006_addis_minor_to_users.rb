class AddisMinorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_minor, :boolean
    add_column :users, :parent_email, :string
  end
end
