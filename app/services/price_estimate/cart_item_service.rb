# frozen_string_literal: true

module PriceEstimate
  class CartService
    attr_accessor :unoccupied_count, :is_save
    attr_reader :cart_item, :is_change

    def initialize(cart_item)
      @cart_item = cart_item
    end

    def call
      @is_change = false
      estimate_price
      cart_item.save! if is_save
    end

    private

    def estimate_price
      return if cart_item.price == current_price

      @is_change = true
      cart_item.price = current_price
    end

    def current_price
      seat_category = cart_item.event_seat.seat_category
      return seat_category.base_price unless cart_item.limited?

      unoccupied_count = seat_category.unoccupied_count if unoccupied_count.blank?
      service = PricePlan::Limited.new(cart_item, unoccupied_count)
      service.call
    end
  end
end
