class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :from_id, :notification_type, :message, :url, :created_at
end