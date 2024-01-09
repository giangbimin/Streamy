# frozen_string_literal: true

class CheckoutService
  def initialize(cart)
    @cart = cart
    @current_user = cart.user
  end

  def call
    @session = create_stripe_session
    @session.url
  end

  private

  def create_stripe_session
    params = {
      customer: stripe_customer_id,
      payment_method_types: ['card'],
      allow_promotion_codes: true,
      mode: 'payment',
      line_items: line_items,
      success_url: "#{success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url
    }
    Stripe::Checkout::Session.create(params)
  end

  def stripe_customer_id
    customer_id = @current_user.stripe_customer_id
    return customer_id if customer_id

    customer = Stripe::Customer.create(email: @current_user.email)
    @current_user.stripe_customer_id = customer.id
    @current_user.save!
    customer.id
  end

  def line_items
    @cart.cart_items.collect do |item|
      { price: item.stripe_price_id, quantity: 1 }
    end
  end
end
