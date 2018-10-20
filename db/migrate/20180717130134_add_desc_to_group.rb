class AddDescToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :desc, :text
  end
end
