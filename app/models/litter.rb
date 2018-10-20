class Litter < ApplicationRecord
  has_and_belongs_to_many :pets
  has_one :pet_dad, :class_name => "Pet", :foreign_key => 'id', :primary_key => 'pet_dad_id'
  has_one :pet_mom, :class_name => "Pet", :foreign_key => 'id', :primary_key => 'pet_mom_id'
end
