# frozen_string_literal: true

class SeatCategory < ApplicationRecord
  belongs_to :event
  has_many :event_seats, dependent: :destroy_async
end
