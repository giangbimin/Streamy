# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :authentication_user!

  private

  def authentication_user!
    @current_user = current_user
    return if @current_user

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end
