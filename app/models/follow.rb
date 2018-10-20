class Follow < ApplicationRecord

  belongs_to :follower, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image, :push_token, :push_token_type)}, :class_name => "User", :foreign_key => 'user_id'
  belongs_to :followed, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image,  :push_token, :push_token_type)}, :class_name => "User", :foreign_key => 'follow_id'

  enum follow_type: [:user_follow, :group_follow]

  def get_role (role)
     return User.role[role]
  end
end
