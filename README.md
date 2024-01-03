
# RE
ticket-booking:

100_tickets: 


- user: email, name
- ticket: category, price, quantity
4 categories: 

CalculatePriceService:
base_price:
current_price:

10 bucket
6000 => 100 + 6000 => (100 * 10%)


[
  {
    type: 'general',
    base_price: 100,
    quantity: 60_000
  },
  {
    type: 'vip',
    base_price: 300,
    quantity: 25_000
  },
  {
    type: 'box',
    base_price: 500,
    quantity: 15_000
  },
  {
    type: 'front-pro',
    base_price: 1000,
    quantity: 5_000
  }
]


card
[
  {
    type: 'front-pro',
    quantity: 500,
    cur_price: 1000,
  },
  {
    type: 'front-pro',
    quantity: 500,
    cur_price: 1100,
  },
]
- cart:
- ticket:
- quantity, price



- Home / list
- Checkout page (Stripe)


ActiveRecord::Schema[7.1].define(version: 2024_01_02_090707) do
  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "type", null: false, default: 0
    t.integer "base_price", null: false, default: 0
    t.integer "quantity", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "ticket_id", null: false
    t.integer "quantity", null: false
    t.integer "current_price", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "status", null: false, default: 0
  end
end
