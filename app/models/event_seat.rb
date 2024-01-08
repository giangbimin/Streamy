# frozen_string_literal: true

class EventSeat < ApplicationRecord
  belongs_to :seat_category
  belongs_to :hall_seat
  enum status: { available: 0, locked: 1, booked: 2 }

  validates :hall_seat_id, uniqueness: { scope: :seat_category_id }

  delegate :name, to: :seat_category, prefix: true
  delegate :event, to: :seat_category
end
