class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :event_seat, null: false, foreign_key: true
      t.integer :price_estimate_rule, null: false, default: 0
      t.float :price, null: false, default: 0

      t.timestamps
    end
  end
end
