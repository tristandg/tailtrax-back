class CreateDirectMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :direct_messages do |t|
      t.integer :user_id
      t.integer :user_id_from
      t.integer :user_id_to
      t.string :content
      t.integer :type
      t.integer :media
      t.integer :media_typeeliala

      t.timestamps
    end
  end
end
