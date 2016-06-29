class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :username
      t.integer :telegram_id, index: true, null: false

      t.timestamps
    end
  end
end
