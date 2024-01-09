# frozen_string_literal: true

module PriceEstimate
  class CartService
    attr_accessor :is_save
    attr_reader :estimate_price, :cart_items, :is_change

    def initialize(cart)
      @cart_items = cart.cart_items.reload
                        .includes(event_seat: [seat_category: :event])
    end

    def call
      reset_attrs
      @cart_items.each do |cart_item|
        estimate_cart_item(cart_item)
        @estimate_price += cart_item.price
      end

      return unless is_save && is_change

      ActiveRecord::Base::transaction do
        cart_items.map(&:save!)
      end
    end

    private

    def reset_attrs
      @is_change = false
      @estimate_price = 0
      @unoccupied_counts = {}
    end

    def estimate_cart_item(cart_item)
      seat_category = cart_item.event_seat.seat_category
      revalidate_cart_item(cart_item, seat_category)
      @unoccupied_counts[seat_category.id] += 1
    end

    def revalidate_cart_item(cart_item, seat_category)
      service = PriceEstimate::CartItemService.new(cart_item)
      service.unoccupied_count = unoccupied_count(seat_category)
      service.call
      @is_change = service.is_change unless is_change
    end

    def unoccupied_count(seat_category)
      @unoccupied_counts[seat_category.id] ||= seat_category.unoccupied_count
      @unoccupied_counts[seat_category.id]
    end
  end
end
