class AddStripeToUserSAndCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :cart_items, :stripe_product_id, :string
    add_column :cart_items, :stripe_price_id, :string
    add_column :cart_items, :currency, :string, default: "usd"
  end
end
