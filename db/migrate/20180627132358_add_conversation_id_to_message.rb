class AddConversationIdToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :direct_messages, :conversation_id, :integer
  end
end
