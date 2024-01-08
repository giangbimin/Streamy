# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :hall
  has_many :seat_categories, dependent: :destroy_async
  has_many :event_seats, through: :seat_categories
end
