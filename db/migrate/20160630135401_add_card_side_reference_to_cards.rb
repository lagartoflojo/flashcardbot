class AddCardSideReferenceToCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :cards, :front_side, foreign_key: { to_table: :card_sides }
    add_reference :cards, :back_side, foreign_key: { to_table: :card_sides }
  end
end
