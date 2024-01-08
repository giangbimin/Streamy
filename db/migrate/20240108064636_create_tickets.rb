class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :event_seat, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :code

      t.timestamps
    end
  end
end
