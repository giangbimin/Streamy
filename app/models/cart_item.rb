# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :event_seat
  enum price_estimate_rule: { limited: 0 }

  default_scope { order(id: :desc) }

  validates :price, numericality: { greater_than_or_equal_to: 0, less_than: 100_000_000 }
  monetize :price, as: :price_cents

  delegate :user, to: :cart
  delegate :seat_category_id, to: :event_seat
  delegate :event, to: :event_seat

  def to_builder
    Jbuilder.new do |cart_item|
      cart_item.price stripe_price_id
      cart_item.quantity 1
    end
  end
end
