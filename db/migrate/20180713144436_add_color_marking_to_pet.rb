class AddColorMarkingToPet < ActiveRecord::Migration[5.1]
  def change
    add_column :pets, :color_id, :integer
    add_column :pets, :marking_id, :integer
  end
end
