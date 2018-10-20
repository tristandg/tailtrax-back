class User < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :businesses
  #has_many :follows
  #
  has_many :followers, :class_name => 'Follow', :foreign_key => 'user_id'
  has_many :followeds, :class_name => 'Follow', :foreign_key => 'follow_id'

  has_many :requestors, :class_name => 'Friend', :foreign_key => 'friend_requestor_id'
  has_many :acceptors, :class_name => 'Friend', :foreign_key => 'friend_acceptor_id'

  has_many :businesses_users

  #belongs_to :business_to_user, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => "Business", :foreign_key => 'business_id'
  #  belongs_to :user_to_business, -> {select(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image)}, :class_name => "User", :foreign_key => 'user_id'
  #(:id, :email, :username, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :role, :gps_location, :address, :city, :state, :zip, :phone, :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :business_name, :bio, :background_image)
  #has_many :user_businesses, -> {select(:id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :business_hours, :user_id, :image, :business_type, :license, :website, :emergency_phone)}, :class_name => 'BusinessesUser', :foreign_key => 'user_id'
  has_many :user_businesses, :class_name => 'BusinessesUser', :foreign_key => 'user_id'
  #has_many :businesses_users, :class_name => 'BusinessesUser', :foreign_key => 'business_id'


  #has_many :sent_alerts, :class_name => 'Alert', :foreign_key => 'sender_user_id'
  #has_many :received_alerts, :class_name => 'AlertsUser', :foreign_key => 'receiver_user_id'


  has_and_belongs_to_many :conversations
  has_many :direct_messages
  has_many :alerts, :foreign_key => "sender_user_id"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # "user", pet_parent", "litter_administrator", "vet", "rescue_admin", "admin", "super_admin""
  enum role: [:user, :pet_parent, :litter_administrator, :vet, :rescue_admin, :admin, :super_admin]
  @@roles = @role

  scope :user_requestors, -> {joins(:requestors).where('users.role = 0')}
  scope :user_acceptors, -> {joins(:acceptors).where('users.role = 0')}
  scope :pet_parent_requestors, -> {joins(:requestors).where('users.role = 1')}
  scope :pet_parent_acceptors, -> {joins(:acceptors).where('users.role = 1')}
  scope :litter_admin_requestors, -> {joins(:requestors).where('users.role = 2')}
  scope :litter_admin_acceptors, -> {joins(:acceptors).where('users.role = 2')}
  scope :vet_requestors, -> {joins(:requestors).where('users.role = 3')}
  scope :vet_acceptors, -> {joins(:acceptors).where('users.role = 3')}
  scope :rescue_admin_requestors, -> {joins(:requestors).where('users.role = 4')}
  scope :rescue_admin_acceptors, -> {joins(:acceptors).where('users.role = 4')}
  scope :admin_requestors, -> {joins(:requestors).where('users.role = 5')}
  scope :admin_acceptors, -> {joins(:acceptors).where('users.role = 5')}
  scope :super_admin_requestors, -> {joins(:requestors).where('users.role = 6')}
  scope :super_admin_acceptors, -> {joins(:acceptors).where('users.role = 6')}

  scope :user_and_pet_parent_requestors, -> {joins(:requestors).where('users.role IN (0,1)')}
  scope :user_and_pet_parent_acceptors, -> {joins(:acceptors).where('users.role IN (0,1)')}

  scope :my_businesses, ->(vet_id) {
    joins(:businesses, :businesses_users).select('businesses.*').where(:id => vet_id)
  }

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def force_authentication_token
    self.authentication_token = generate_authentication_token
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def self.find_by_authentication_token(api_token = nil)
    if api_token
      where("authentication_token" => api_token).first
    end
  end
end
