class UpdateSocialPostLikes < ActiveRecord::Migration[5.1]
  def change
    rename_column :social_likes, :social_post, :social_post_id
  end
end
