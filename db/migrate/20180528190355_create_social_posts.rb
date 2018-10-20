class CreateSocialPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :social_posts do |t|
      t.integer :user_id
      t.integer :type
      t.string :title
      t.string :content
      t.string :media
      t.integer :media_type

      t.timestamps
    end
  end
end
