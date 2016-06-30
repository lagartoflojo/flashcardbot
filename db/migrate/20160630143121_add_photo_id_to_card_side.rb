class AddPhotoIdToCardSide < ActiveRecord::Migration[5.0]
  def change
    add_column :card_sides, :photo_id, :string
  end
end
