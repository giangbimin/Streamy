class CreateHalls < ActiveRecord::Migration[7.1]
  def change
    create_table :halls do |t|
      t.string :name, null: false
      t.integer :seat_amount, null: false, default: 0

      t.timestamps
    end
  end
end
