# frozen_string_literal: true

class PaymentForm
  include ActiveModel::Model
  attr_accessor :stripe_session_id, :is_success

  validates :stripe_session_id, presence: true

  before_save :find_order, :initial_cache

  def save
    return false unless valid?

    notify_user_payment_status(is_success)
    is_success ? when_success : when_not_success
  end

  private

  def initial_cache
    return unless @order

    @cart = @order.cart
    @cart_items = @cart.cart_items
    event_seat_ids = @cart_items.map(&:event_seat_id)
    @event_seats = EventSeat.where(id: event_seat_ids)
    @seat_categories = @event_seats.group('seat_category_id').count
    # session_detail = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ['line_items'] })
    # stripe_product_ids = session_detail.line_items.data.map { |line_item| line_item.price.product }
  rescue StandardError
    errors.add(:base, 'not found')
  end

  def find_order
    # stripe_session_id = stripe_payment.data.object.id.id
    @order = Order.find_by(stripe_session_id: stripe_session_id)
    return errors.add(:base, 'Not found') if @order.blank?

    errors.add(:base, 'Already Requested') unless @order.processing?
  end

  def when_success
    status = false
    ActiveRecord::Base.transaction do
      @cart.update!(status: :done)
      @event_seats.update_all(status: :booked) # rubocop:disable Rails/SkipsModelValidations
      @order.update!(status: :success)
      generate_tickes
      status = true
    end
    sent_user_email_tickets if status
    status
  end

  def when_not_success
    status = false
    ActiveRecord::Base.transaction do
      @cart.update!(status: :unactive)
      @event_seats.update_all(status: :available) # rubocop:disable Rails/SkipsModelValidations
      @seat_categories.each { |id, count| SeatCategory.find_by(id).decrement(:unoccupied_count, count) }
      @order.update!(status: :failed)
      status = true
    end
    status
  end

  def generate_tickes
    tickets = @event_seats.map { |event_seat| { event_seat_id: event_seat.id, order_id: order.id } }
    Ticket.insert_all(tickets) # rubocop:disable Rails/SkipsModelValidations
  end

  def sent_user_email_tickets
    # TODO: create mailer
  end

  def notify_user_payment_status(status)
    # TODO: create mailer
  end
end
