class AddCurrentDeckIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :current_deck, foreign_key: { to_table: :decks }
  end
end
