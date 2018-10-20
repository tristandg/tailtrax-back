class UpdatePhrMedVacDiag < ActiveRecord::Migration[5.1]
  def change
    add_column :pet_health_records, :medication_id, :integer
    add_column :pet_health_records, :vaccine_id, :integer
    add_column :pet_health_records, :diagnosis_id, :integer
  end
end
