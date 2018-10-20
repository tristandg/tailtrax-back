class FriendSerializer < ActiveModel::Serializer
  attributes :id, :requestor, :acceptor
end
