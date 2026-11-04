# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_04_172012) do
  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quote_id", null: false
    t.string "description", null: false
    t.decimal "quantity", precision: 8, scale: 2, default: "1.0", null: false
    t.integer "unit_price_cents", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quote_id"], name: "index_line_items_on_quote_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "title", null: false
    t.string "status", default: "draft", null: false
    t.string "share_token"
    t.integer "tax_rate_bps", default: 500, null: false
    t.datetime "accepted_at"
    t.string "accepted_by_name"
    t.integer "accepted_total_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_quotes_on_client_id"
    t.index ["share_token"], name: "index_quotes_on_share_token", unique: true
  end

  add_foreign_key "line_items", "quotes"
  add_foreign_key "quotes", "clients"
end
