class UserConversationSerializer < ActiveModel::Serializer
  attributes :id, :guid, :users, :created_at, :updated_at
end

