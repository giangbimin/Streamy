class CreateEventSeats < ActiveRecord::Migration[7.1]
  def change
    create_table :event_seats do |t|
      t.references :seat_category, null: false, foreign_key: true
      t.references :hall_seat, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :event_seats, [:hall_seat_id, :seat_category_id], unique: true
  end
end
