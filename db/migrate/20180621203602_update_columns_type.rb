class UpdateColumnsType < ActiveRecord::Migration[5.1]
  def change
    rename_column :conditions, :type, :condition_type
    rename_column :direct_messages, :type, :direct_message_type
    rename_column :social_comments, :type, :social_comment_type
    rename_column :social_likes, :type, :social_like_type
    rename_column :social_posts, :type, :social_post_type
  end
end
