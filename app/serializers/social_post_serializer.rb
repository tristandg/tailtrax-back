class SocialPostSerializer < ActiveModel::Serializer
  attributes :id, :user, :social_post_type, :title, :content, :media, :media_type, :social_likes, :social_comments, :created_at

  def user
    {
        'id' => object.user.id,
        'first_name' => object.user.first_name,
        'last_name' => object.user.last_name,
        'username' => object.user.username,
        'profile_image' => object.user.profile_image,
        'role' => object.user.role,
    }
  end

  def social_comments
    @comments = object.social_comments.map do |c|
      SocialCommentSerializer.new(c)
    end

    @comments
  end

  def social_likes
    @likes = object.social_likes.map do |l|
      SocialLikeSerializer.new(l)
    end

    @likes
  end
end