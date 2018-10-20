class GroupMembersSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :is_private, :user_id, :users, :desc
end
