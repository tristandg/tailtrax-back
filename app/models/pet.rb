class Pet < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :litters
  has_and_belongs_to_many :businesses
  has_many :pet_health_records

  belongs_to :pet_color, optional: true, foreign_key: 'color_id'
  belongs_to :pet_marking, optional: true, foreign_key: 'marking_id'
  belongs_to :pet_breed, optional: true

  has_many :vaccines, :through => :pet_health_records
  has_many :diagnoses, :through => :pet_health_records
  has_many :medications, :through => :pet_health_records

  #belongs_to :pet_to_business, -> {select(:id, :user_id, :name, :gender, :weight, :pet_description, :pet_profile_pic, :pet_breed_id, :color_id, :location, :microchip, :akc_reg_number, :akc_reg_date, :birthday, :food, :supplemental, :health_issue, :marking_id, :litter_id, :background_image)}, :class_name => "Pet", :foreign_key => 'pet_id'
  has_many :biz, :class_name => 'BusinessesPet', :foreign_key => 'pet_id'
  has_many :pet_to_business, :class_name => 'BusinessesPet', :foreign_key => 'pet_id'

  # has_many :businesses
  has_many :businesses_pets

  scope :biz_pets, ->(biz_id) {
    #joins(:businesses_pets).select('pets.*').where(:id => biz_id)
    joins(:businesses_pets).select('pets.*').where("businesses_pets.business_id = #{biz_id}")
  }

end
