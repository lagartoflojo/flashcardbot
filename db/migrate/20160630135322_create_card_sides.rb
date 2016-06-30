class CreateCardSides < ActiveRecord::Migration[5.0]
  def change
    create_table :card_sides do |t|
      t.string :text

      t.timestamps
    end
  end
end
