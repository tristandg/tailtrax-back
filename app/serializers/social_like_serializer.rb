class SocialLikeSerializer < ActiveModel::Serializer
  attributes :id, :user, :social_post, :social_like_type

  def user
    {
        'id' => object.user.id,
        'first_name' => object.user.first_name,
        'last_name' => object.user.last_name,
        'profile_image' => object.user.profile_image
    }
  end
end