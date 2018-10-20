class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :admin, :phone, :location, :city, :state, :zip,
             :first_name, :last_name, :website, :is_minor, :parent_email, :profile_image, :background_image,
             :website, :bio, :business_name, :username
end