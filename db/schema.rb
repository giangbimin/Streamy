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

ActiveRecord::Schema[7.1].define(version: 2024_01_09_203834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "event_seat_id", null: false
    t.integer "price_estimate_rule", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.string "currency", default: "usd"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["event_seat_id"], name: "index_cart_items_on_event_seat_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "event_seats", force: :cascade do |t|
    t.bigint "seat_category_id", null: false
    t.bigint "hall_seat_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall_seat_id", "seat_category_id"], name: "index_event_seats_on_hall_seat_id_and_seat_category_id", unique: true
    t.index ["hall_seat_id"], name: "index_event_seats_on_hall_seat_id"
    t.index ["seat_category_id"], name: "index_event_seats_on_seat_category_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.bigint "hall_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall_id"], name: "index_events_on_hall_id"
  end

  create_table "hall_seats", force: :cascade do |t|
    t.integer "seat_number", null: false
    t.bigint "hall_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall_id"], name: "index_hall_seats_on_hall_id"
  end

  create_table "halls", force: :cascade do |t|
    t.string "name", null: false
    t.integer "seat_amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "total_price", default: 0, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_session_id"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.integer "transaction_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "seat_categories", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", null: false
    t.float "base_price", default: 0.0, null: false
    t.integer "quantity", default: 0, null: false
    t.integer "unoccupied_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_seat_categories_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "event_seat_id", null: false
    t.bigint "order_id", null: false
    t.integer "status", default: 0, null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_seat_id"], name: "index_tickets_on_event_seat_id"
    t.index ["order_id"], name: "index_tickets_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "event_seats"
  add_foreign_key "carts", "users"
  add_foreign_key "event_seats", "hall_seats"
  add_foreign_key "event_seats", "seat_categories"
  add_foreign_key "events", "halls"
  add_foreign_key "hall_seats", "halls"
  add_foreign_key "orders", "carts"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "users"
  add_foreign_key "seat_categories", "events"
  add_foreign_key "tickets", "event_seats"
  add_foreign_key "tickets", "orders"
end
