class BusinessUsersSerializer < ActiveModel::Serializer
  #attributes :id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :image, :business_hours, :emergency_phone, :website, :user_id, :users, :business_to_users

  #belongs_to :business_to_user, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => "Business", :foreign_key => 'business_id'
  #belongs_to :user_to_business, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image)}, :class_name => "User", :foreign_key => 'user_id'
  attributes :id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :image, :business_hours, :emergency_phone, :website, :user_id #, :business_to_user, :user_to_business

  def users
    object.users.map do |user|
      UserSerializer.new(user)
    end
  end
end
