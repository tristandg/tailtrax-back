class CreateDiagnoses < ActiveRecord::Migration[5.1]
  def change
    create_table :diagnoses do |t|
      t.string :name
      t.string :desc
      t.integer :severity

      t.timestamps
    end
  end
end
