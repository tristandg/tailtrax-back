class ChangePhoneToString < ActiveRecord::Migration[5.1]
  def change
    change_column :businesses, :phone, :string
    add_column :businesses, :license, :string
    add_column :businesses, :website, :string
  end
end
