class ChangingContentToText < ActiveRecord::Migration[5.1]
  def change
    change_column :social_posts, :content, :text
  end
end
