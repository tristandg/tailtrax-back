class CreateSocialLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :social_likes do |t|
      t.integer :user_id
      t.integer :social_post
      t.integer :type

      t.timestamps
    end
  end
end
