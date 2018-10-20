class LitterSerializer < ActiveModel::Serializer
  attributes :id, :name, :litter_description, :pet_mom_id, :pet_dad_id, :pets, :pet_dad, :pet_mom, :birthday
end