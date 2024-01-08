# frozen_string_literal: true

module PriceEstimateRule
  class Base
    attr_reader :cart_item

    def initialize(cart_item, *_agrs)
      @cart_item = cart_item
      seat_category = cart_item.event_seat.seat_category
      @base_price = seat_category.base_price
      @total_seat = seat_category.quantity
    end

    def call
      cart_item.price = @base_price
      cart_item
    end
  end
end
