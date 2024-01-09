# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user
      log_in(user)
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
