class SocialComment < ApplicationRecord
  belongs_to :social_post
  belongs_to :user

  belongs_to :group, optional: true
end
