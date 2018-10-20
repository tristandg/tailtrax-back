class PostReport < ApplicationRecord
  belongs_to :user
  belongs_to :social_post, foreign_key: 'post_id'
end
