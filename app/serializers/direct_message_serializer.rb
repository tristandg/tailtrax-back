class DirectMessageSerializer < ActiveModel::Serializer
  attributes :id, :user, :content, :direct_message_type, :media, :media_type, :created_at

end