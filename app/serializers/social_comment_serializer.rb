class SocialCommentSerializer < ActiveModel::Serializer
  attributes :id, :user, :social_post, :content, :social_comment_type, :media, :media_type

  def user
    {
        'id' => object.user.id,
        'first_name' => object.user.first_name,
        'last_name' => object.user.last_name,
        'username' => object.user.username,
        'profile_image' => object.user.profile_image
    }
  end
end