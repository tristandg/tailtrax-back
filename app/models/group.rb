class Group < ApplicationRecord
  belongs_to :user
  has_many :social_posts

  has_and_belongs_to_many :users
end
