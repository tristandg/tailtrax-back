class Business < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :users
  has_and_belongs_to_many :pets

  #has_many :petz, :class_name => "BusinessesPet", :foreign_key => 'business_id'
  has_many :business_to_pet, :class_name => "BusinessesPet", :foreign_key => 'business_id'
  #belongs_to :business_to_user, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => "Business", :foreign_key => 'business_id'
  has_many :business_to_users, :class_name => "BusinessesUser", :foreign_key => 'business_id'

  # works!
  scope :petz, -> { joins(:business_to_pet) }
  #https://stackoverflow.com/questions/15229000/adding-parameter-to-a-scope
  # http://blog.plataformatec.com.br/2013/02/active-record-scopes-vs-class-methods/
  #scope :filter_petz, ->()

  serialize :business_hours, Array

  #has_many :followers, :class_name => 'Follow', :foreign_key => 'user_id'
  #has_many :followeds, :class_name => 'Follow', :foreign_key => 'follow_id'
  #belongs_to :business, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => "Business", :foreign_key => 'business_id'
  #belongs_to :pet, -> {select(:id, :user_id, :name, :gender, :weight, :pet_description, :pet_profile_pic, :pet_breed_id, :color_id, :location, :microchip, :akc_reg_number, :akc_reg_date, :birthday, :food, :supplemental, :health_issue, :marking_id, :litter_id, :background_image)}, :class_name => "Pet", :foreign_key => 'pet_id'

  #has_many :business_to_pets, :class_name => 'BusinessPet', :foreign_key => 'business_id'
  #scope :user_requestors, -> { joins(:requestors).where('users.role = 0')}
  #scope :user_acceptors, -> { joins(:acceptors).where('users.role = 0')}

  enum business_type: [:litter_administrator, :vet, :rescue_admin]
end
