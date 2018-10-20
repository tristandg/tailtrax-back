class AddUserColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer

    change_table :users do |t|
      t.string :authentication_token
      t.datetime :token_expires
      t.boolean :admin
    end

    add_index  :users, :authentication_token, :unique => true

    add_column :users, :gps_location, :string
    add_column :users, :location, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
    add_column :users, :phone, :string

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
