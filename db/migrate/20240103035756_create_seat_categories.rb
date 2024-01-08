class CreateSeatCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :seat_categories do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false
      t.float :base_price, null: false, default: 0
      t.integer :quantity, null: false, default: 0
      t.integer :unoccupied, null: false, default: 0

      t.timestamps
    end
  end
end
