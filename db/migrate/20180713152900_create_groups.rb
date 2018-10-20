class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :image
      t.boolean :private
      t.integer :user_id

      t.timestamps
    end
  end
end
