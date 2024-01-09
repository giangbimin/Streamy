# frozen_string_literal: true

module StripeIndex
  class CartItemService
    attr_reader :cart_item

    def initialize(cart_item)
      @cart_item = cart_item
    end

    def call
      return if cart_item.stripe_price_id.present?

      create_stripe_price_id
      cart_item.save! if is_new
    end

    private

    def create_stripe_price_id
      product, price = stripe_call
      cart_item.stripe_product_id = product.id
      cart_item.stripe_price_id = price.id
    end

    def stripe_call
      seat_category = cart_item.event_seat.seat_category
      product = Stripe::Product.create(name: "#{seat_category.event.name} Ticket, Category #{seat_category.name}")
      price = Stripe::Price.create(product: product, unit_amount: cart_item.price, currency: cart_item.currency)
      [product, price]
    end
  end
end
