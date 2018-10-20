class AddBioToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bio, :text, :limit => 4294967295
  end
end
