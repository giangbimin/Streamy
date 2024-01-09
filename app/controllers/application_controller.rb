# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :authenticate_user!, :find_cart

  private

  def authenticate_user!
    @current_user = current_user
    return if @current_user

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def find_cart
    return unless @current_user

    @current_cart = @current_user.carts.active.first ||
                    @current_user.carts.active.create
  end
end
