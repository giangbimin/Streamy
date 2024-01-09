# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = @current_user.orders
  end

  def create
    checkout = CheckoutForm.new(create_order_params[:cart_id])
    if checkout.save
      redirect_to checkout.striper_session.url
    else
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def success
    if params[:session_id].present?
      @session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ['line_items']})
      item_ids = @session_with_expand.line_items.data.map do |line_item|
        line_item.price.product
      end
      CartItem.where(stripe_product_id: item_ids)
    else
      redirect_to cancel_url, alert: 'No info to display'
    end
  end

  def cancel; end

  private

  def create_order_params
    params.require(:order).permit(:cart_id)
  end
end
