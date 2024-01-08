class CreateHallSeats < ActiveRecord::Migration[7.1]
  def change
    create_table :hall_seats do |t|
      t.integer :seat_number, null: false
      t.references :hall, null: false, foreign_key: true

      t.timestamps
    end
  end
end
