class AlertSerializer < ActiveModel::Serializer
  def receiver
     object.users
  end
  def sender
     object.user
  end
  #attributes :id, :sender_user_id, :date_to_send, :content, :users, :user, :date_to_send
  attributes :id, :sender_user_id, :date_to_send, :content, :sender, :receiver, :date_to_send

  def users
    object.users.map do |user|
      UserSerializer.new(user)
    end
  end

end