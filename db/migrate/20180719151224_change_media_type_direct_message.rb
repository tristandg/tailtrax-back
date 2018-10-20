class ChangeMediaTypeDirectMessage < ActiveRecord::Migration[5.1]
  def change
    change_column :direct_messages, :media, :string
  end
end
