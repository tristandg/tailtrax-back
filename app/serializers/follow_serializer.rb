class FollowSerializer < ActiveModel::Serializer
  attributes :id, :follow_id, :follower, :followed
end
