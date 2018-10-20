class CreateJoinTableBusinessPets < ActiveRecord::Migration[5.1]
  def change
    create_join_table :businesses, :pets do |t|

    end
  end
end
