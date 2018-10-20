class UpdateSocialComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :social_comments, :social_post, :social_post_id
  end
end
