class CreateVaccines < ActiveRecord::Migration[5.1]
  def change
    create_table :vaccines do |t|
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
