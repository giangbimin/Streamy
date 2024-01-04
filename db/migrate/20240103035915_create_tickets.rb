class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.integer :type, null: false, default: 0
      t.integer :base_price, null: false, default: 0
      t.integer :quantity, null: false, default: 0
      t.integer :current_quantity, null: false, default: 0

      t.timestamps
    end
  end
end
