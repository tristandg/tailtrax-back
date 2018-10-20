class BusinessSerializer < ActiveModel::Serializer
  attributes :id, :name, :desc, :address, :city, :state, :zip, :email, :phone, :image, :business_hours, :emergency_phone, :website, :user_id
end