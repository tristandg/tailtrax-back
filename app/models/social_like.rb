class SocialLike < ApplicationRecord
  belongs_to :social_post
  belongs_to :user
end
