class AlertsUserSerializer < ActiveModel::Serializer
  # commented this out and may need to reinstate?
  #attributes :id, :sent_alert, :received_alert
  attributes :id, :alerts, :receiver

  def receiver
    user = User.find_by(id: object.receiver_user_id)

    UserSerializer.new(user)
  end

end
