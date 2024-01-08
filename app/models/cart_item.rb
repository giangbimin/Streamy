# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :event_seat
  enum price_estimate_rule: { limited: 0 }

  default_scope { order(id: :desc) }

  delegate :user, to: :cart
  delegate :seat_category_id, to: :event_seat
end
