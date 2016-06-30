class AddChatStatusToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :chat_status, :integer, null: false, default: 0
  end
end
