# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :revalidate_cart, only: %i[index]
  before_action :find_cart_item, only: %i[destroy]
  before_action :find_event_seats, only: %i[create]

  def index; end

  def create
    cart_items = (@event_seats || []).map do |event_seat|
      { event_seat_id: event_seat.id, cart_id: @current_cart.id }
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
    @cart_item.destroy
    revalidate_cart
    respond_to do |format|
      format.turbo_stream do
        render_cart_items
      end
    end
  end

  private

  def find_cart_item
    @cart_item = CartItem.find_by(id: params[:id])
  end

  def find_event_seats
    @event_seats = if cart_item_params[:event_seat_id].present?
                     event_seats_for_batch_create
                   else
                     event_seats_for_quick_create
                   end
  end

  def event_seats_for_batch_create
    EventSeat.available.where(id: cart_item_params[:event_seat_ids])
  end

  def event_seats_for_quick_create
    current_event_seat_ids = @current_cart.cart_items.pluck(:event_seat_id)
    EventSeat.available.where(seat_category_id: quick_add_params[:seat_category_id])
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
    @service = CartEstimateService.new(@current_cart)
    @service.call
    @cart_items = @service.cart_items
    @total_item = @cart_items.count
    @estimate_price = @service.estimate_price
  end

  def render_cart_items
    render turbo_stream: [
      turbo_stream.replace(@current_cart, partial: 'cart_items/cart_items',
                                          locals: { cart_items: @current_cart.cart_items.reload, cart: @current_cart }),
      turbo_stream.update(ActionView::RecordIdentifier.dom_id(@current_cart, :total_item), html: @total_item),
      turbo_stream.update(ActionView::RecordIdentifier.dom_id(@current_cart, :estimate_price), html: @estimate_price),
      turbo_stream.update(ActionView::RecordIdentifier.dom_id(@current_cart, :final_total_item), html: @total_item),
      turbo_stream.update(ActionView::RecordIdentifier.dom_id(@current_cart, :final_estimate_price), html: @estimate_price)
    ]
  end
end
