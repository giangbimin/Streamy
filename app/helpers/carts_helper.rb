# frozen_string_literal: true

module CartsHelper
  def current_cart
    cart = Cart.find_by(id: session[:cart_id]) || Cart.create(user_id: current_user.id)
    session[:cart_id] = cart.id
    cart
  end
end
