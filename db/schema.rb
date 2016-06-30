# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160630232241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_sides", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "photo_id"
    t.string   "document_id"
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "deck_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "front_side_id"
    t.integer  "back_side_id"
    t.index ["back_side_id"], name: "index_cards_on_back_side_id", using: :btree
    t.index ["deck_id"], name: "index_cards_on_deck_id", using: :btree
    t.index ["front_side_id"], name: "index_cards_on_front_side_id", using: :btree
  end

  create_table "decks", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_decks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                  null: false
    t.string   "last_name"
    t.string   "username"
    t.integer  "telegram_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "chat_status",     default: 0, null: false
    t.integer  "current_deck_id"
    t.index ["current_deck_id"], name: "index_users_on_current_deck_id", using: :btree
    t.index ["telegram_id"], name: "index_users_on_telegram_id", using: :btree
  end

  add_foreign_key "cards", "card_sides", column: "back_side_id"
  add_foreign_key "cards", "card_sides", column: "front_side_id"
  add_foreign_key "cards", "decks"
  add_foreign_key "decks", "users"
  add_foreign_key "users", "decks", column: "current_deck_id"
end
