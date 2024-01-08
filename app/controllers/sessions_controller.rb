# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authentication_user!, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:sessions][:email].downcase)

    if user
      log_in(user)
      redirect_back_or(root_url)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
