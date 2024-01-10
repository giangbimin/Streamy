# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = @current_user.orders
  end

  def create
    @cart = Cart.find_by(id: create_order_params[:cart_id])
    checkout = CheckoutForm.new(cart_id: create_order_params[:cart_id])
    status = checkout.save
    if status
      redirect_to checkout.striper_session.url
    else
      redirect_to @cart, alert: checkout.errors.full_messages
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def success
    if params[:session_id].present?
      @session = Stripe::Checkout::Session.retrieve({ id: params[:session_id] })
      PaymentForm.create(stripe_payment_id: params[:session_id], is_success: success)
      @order = Order.find_by(stripe_payment_id: params[:session_id])
      redirect_to @order, alert: 'Payment Success'
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
