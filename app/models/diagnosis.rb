class Diagnosis < ApplicationRecord
  has_many :pet_health_records

  enum severity: [:low, :high]
end
