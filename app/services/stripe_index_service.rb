# frozen_string_literal: true

class StripeIndex
  attr_reader :cart_item

  def initialize(cart_item)
    @cart_item = cart_item
  end

  def call
    product, price = stripe_call
    cart_item.stripe_product_id = product.id
    cart_item.stripe_price_id = price.id
  end

  private

  def stripe_call
    product = Stripe::Product.create(name: "#{@event.name} Ticket, Category #{@seat_category.name}")
    price = Stripe::Price.create(product: product, unit_amount: cart_item.price, currency: cart_item.currency)
    [product, price]
  end
end
