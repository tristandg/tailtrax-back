class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :is_private, :user_id, :desc
end
