class PetHealthRecord < ApplicationRecord
  belongs_to :pet
  has_many :conditions

  belongs_to :diagnosis, optional: true
  belongs_to :medication, optional: true
  belongs_to :vaccine, optional: true

  serialize :reminders, Array
end
