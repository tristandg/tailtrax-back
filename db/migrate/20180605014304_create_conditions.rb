class CreateConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :conditions do |t|
      t.integer :type
      t.string :name
      t.string :desc
      t.integer :severity

      t.timestamps
    end
  end
end
