class RenamePrivateToIsPrivate < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :private, :is_private
  end
end
