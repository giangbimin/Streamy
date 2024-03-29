class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :cart, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :total_price, null: false, default: 0
      t.string :description

      t.timestamps
    end
  end
end
