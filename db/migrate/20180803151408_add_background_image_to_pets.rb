class AddBackgroundImageToPets < ActiveRecord::Migration[5.1]
  def change
    add_column :pets, :background_image, :string
  end
end
