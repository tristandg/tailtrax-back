class CreateSocialComments < ActiveRecord::Migration[5.1]
  def change
    create_table :social_comments do |t|
      t.integer :user_id
      t.integer :social_post
      t.string :content
      t.integer :type
      t.string :media
      t.integer :media_type

      t.timestamps
    end
  end
end
