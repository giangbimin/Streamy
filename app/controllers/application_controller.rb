# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authentication_user!
  before_action :initialize_cart

  private

  def authentication_user!
    @current_user = current_user
    return if @current_user

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def initialize_cart
    @current_cart = current_cart
  end
end
