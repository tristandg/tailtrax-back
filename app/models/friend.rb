class Friend < ApplicationRecord

  belongs_to :requestor, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image)}, :class_name => "User", :foreign_key => 'friend_requestor_id'
  belongs_to :acceptor, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image)}, :class_name => "User", :foreign_key => 'friend_acceptor_id'
  #has_many :sent_alerts, :class_name => 'Alert', :foreign_key => 'sender_user_id'
  #has_many :received_alerts, :class_name => 'AlertUser', :foreign_key => 'receiver_user_id'

end
