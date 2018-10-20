class AddGroupIdToSocialPost < ActiveRecord::Migration[5.1]
  def change
    add_column :social_posts, :group_id, :integer
  end
end
