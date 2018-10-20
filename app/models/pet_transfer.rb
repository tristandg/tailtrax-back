class PetTransfer < ApplicationRecord
  before_create :set_defaults

  def set_defaults
    self.accepted ||= false
  end

  belongs_to :user
  belongs_to :pet
end
