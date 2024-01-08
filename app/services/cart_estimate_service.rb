# frozen_string_literal: true

class CartEstimateService
  attr_reader :total_price, :cart_items

  def initialize(cart)
    @cart_items = cart.cart_items.reload.includes(event_seat: :seat_category)
    @estimate_price = 0
    @unoccupied_map = {}
  end

  def call
    @cart_items.each do |cart_item|
      estimate(cart_item)
      @estimate_price += cart_item.price
    end
  end

  private

  def estimate(cart_item)
    seat_category = cart_item.event_seat.seat_category
    @unoccupied_map[seat_category.id] ||= seat_category.unoccupied
    if cart_item.limited?
      service = PriceEstimateRule::Limited.new(cart_item, @unoccupied_map[seat_category.id])
      service.call
    else
      cart_item.price = seat_category.base_price
    end
    @unoccupied_map[seat_category.id] += 1
  end
end
