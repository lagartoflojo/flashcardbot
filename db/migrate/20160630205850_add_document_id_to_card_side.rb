class AddDocumentIdToCardSide < ActiveRecord::Migration[5.0]
  def change
    add_column :card_sides, :document_id, :string
  end
end
