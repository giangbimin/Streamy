# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_ticket, only: :add

  def add
    update_cart
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('cart', partial: 'cart/cart', locals: { cart: @cart }),
          turbo_stream.replace(@ticket)
        ]
      end
    end
  end

  def remove
    CartItem.find_by(id: params[:id]).destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('cart', partial: 'cart/cart', locals: { cart: @cart })
      end
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find_by(id: params[:id])
  end

  def quantity
    params[:quantity].to_i
  end

  def update_cart
    if quantity.positive?
      @cart.cart_items.find_or_created_by(ticket_id: @ticket.id)
    else
      @cart.cart_items.where(ticket_id: @ticket.id).destroy_all
    end
  end
end
