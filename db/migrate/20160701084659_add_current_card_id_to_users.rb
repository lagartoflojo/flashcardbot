class AddCurrentCardIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :current_card, foreign_key: { to_table: :cards }
  end
end
