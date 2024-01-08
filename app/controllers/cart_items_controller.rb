# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :find_cart, except: %i[destroy]
  before_action :revalidate_cart, only: %i[index]
  before_action :find_cart_item, only: %i[destroy]
  before_action :find_event_seats, only: %i[create]

  def index
    @cart_items = @service.cart_items
    @total_item = @cart_items.count
    @total_price = @service.total_price
  end

  def create
    cart_items = (@event_seats || []).map do |event_seat|
      { event_seat_id: event_seat.id, cart_id: @cart.id }
    end
    CartItem.insert_all(cart_items) # rubocop:disable Rails/SkipsModelValidations
    revalidate_cart
    respond_to do |format|
      format.turbo_stream do
        render_cart_items
      end
    end
  end

  def destroy
    @cart = @cart_item.cart
    @cart_item.destroy
    revalidate_cart
    respond_to do |format|
      format.turbo_stream do
        render_cart_items
      end
    end
  end

  private

  def find_cart
    @cart = @current_user.carts.active.first || @current_user.carts.create(status: :active)
  end

  def find_cart_item
    @cart_item = CartItem.find_by(id: params[:id])
  end

  def find_event_seats
    if cart_item_params[:event_seat_id].present?
      @event_seats = EventSeat.available.where(id: cart_item_params[:event_seat_ids])
      return
    end
    current_event_seat_ids = @cart.cart_items.pluck(:event_seat_id)
    @event_seats = EventSeat.available.where(seat_category_id: quick_add_params[:seat_category_id])
                            .where.not(id: current_event_seat_ids)
                            .limit((quick_add_params[:quantity] || 1).to_i)
  end

  def cart_item_params
    params.require(:cart_items).permit(event_seat_ids: [])
  end

  def quick_add_params
    params.require(:cart_items).permit(:seat_category_id, :quantity)
  end

  def revalidate_cart
    @service = CartEstimateService.new(@cart)
    @service.call
  end

  def render_cart_items
    render turbo_stream: turbo_stream.replace(@cart, partial: 'cart_items/cart_items',
                                                     locals: { cart_items: @cart.cart_items.reload,
                                                               cart: @cart })
  end
end
