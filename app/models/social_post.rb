class SocialPost < ApplicationRecord
  belongs_to :user
  has_many :social_likes
  has_many :social_comments
  belongs_to :group, optional: true

  enum media_type: [:image, :video]
  enum social_post_type: [:main_post, :group_post]
end
