class BusinessesPetSerializer < ActiveModel::Serializer
  #attributes :id, :business_id, :pet_id, :business_to_pet, :pet_to_business
  #attributes :id, :business_to_pet, :pet_to_business
  attributes  :businesses, :businesses_users

end
