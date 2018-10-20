class CreateBusinessUserJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :businesses, :users do |t|

    end
  end
end
