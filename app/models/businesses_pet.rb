# Creating Multiple Associations With the Same Table
# https://www.spacevatican.org/2008/5/6/creating-multiple-associations-with-the-same-table/
class BusinessesPet < ApplicationRecord
  belongs_to :business_to_pet, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => "Business", :foreign_key => 'business_id'
  belongs_to :pet_to_business, -> {select(:id, :user_id, :name, :gender, :weight, :pet_description, :pet_profile_pic, :pet_breed_id, :color_id, :location, :microchip, :akc_reg_number, :akc_reg_date, :birthday, :food, :supplemental, :health_issue, :marking_id, :litter_id, :background_image)}, :class_name => "Pet", :foreign_key => 'pet_id'

  #belongs_to :user
  #has_and_belongs_to_many :users
  #has_and_belongs_to_many :pets
  #serialize :business_hours, Array

  #enum business_type: [:litter_administrator, :vet, :rescue_admin]
end
