# frozen_string_literal: true

class CheckoutForm
  include ActiveModel::Model
  attr_accessor :cart_id
  attr_reader :stripe_session

  validates :cart_id, presence: true
  validate :validate_price
  before_save :revalidate_stripe_user, :revalidate_stripe_line_items

  def save
    return false unless valid?

    initial_cache
    ActiveRecord::Base.transaction do
      checkout
    end
    stripe_call
  end

  private

  def initial_cache
    @cart = Cart.find_by(id: cart_id)
    @user = @cart.user
    @cart_items = @cart.cart_items
    event_seat_ids = @cart_items.map(&:event_seat_id)
    @event_seats = EventSeat.where(id: event_seat_ids)
    @seat_categories = @event_seats.group('seat_category_id').count
  end

  def revalidate_stripe_user
    @stripe_customer_id = StripeIndex::UserService.new(@user).call
  end

  def revalidate_stripe_line_items
    return unless @cart_items.map(&:stripe_price_id).include?(nil)

    @cart_items.each do |cart_item|
      next if cart_item.stripe_price_id.present?

      StripeIndex::CartItemService.new(cart_item).call
    end
  end

  def validate_price
    service = PriceEstimate::CartService.new(cart)
    service.call
    error.add(:cart_id, 'price already changed') if service.is_change
  end

  def checkout
    @cart.update!(status: :checkout)
    @event_seats.update_all(status: :locked) # rubocop:disable Rails/SkipsModelValidations
    @seat_categories.each do |id, count|
      SeatCategory.find_by(id).increment(:unoccupied_count, count)
    end
    @order = Order.create(cart_id: cart_id, user_id: @user.id)
  end

  def line_items
    @cart_items.collect { |item| { price: item.stripe_price_id, quantity: 1 } }
  end

  def stripe_call
    striper_params = {
      customer: @stripe_customer_id,
      payment_method_types: ['card'],
      line_items: line_items,
      allow_promotion_codes: true,
      mode: 'payment',
      success_url: "#{success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url
    }
    @stripe_session = Stripe::Checkout::Session.create(striper_params)
  end

  # def success_payment
  #   create_payment
  #   create_tickets
  #   notification_to_user
  # end

  # def create_payment
  #   Payment.create(stripe_session_id: @stripe_session.id, cart_id: @cart.id, user_id: @user.id,
  #                  transaction_status: :paid)
  # end

  # def create_tickets
  #   @cart_items.each do |cart_item|
  #     Ticket.create(event_seat_id: cart_item.event_seat_id, order_id: @order.id)
  #   end
  # end

  def notification_to_user
    # TODO: Email To User @order
  end
end
