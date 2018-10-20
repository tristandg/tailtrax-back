class AddStuffToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :email, :string
    add_column :businesses, :phone, :integer
    add_column :businesses, :business_hours, :string
    add_column :businesses, :user_id, :integer
    add_column :businesses, :image, :string
  end
end
