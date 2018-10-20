class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :guid, :direct_messages, :users


  def direct_messages
    object.direct_messages.map do |dm|
      DirectMessageSerializer.new(dm)
    end
  end
end
