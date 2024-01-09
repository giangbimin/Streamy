# frozen_string_literal: true

module StripeIndex
  class UserService
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      stripe_customer_id
    end

    private

    def stripe_customer_id
      customer_id = user.stripe_customer_id
      return customer_id if customer_id

      customer = Stripe::Customer.create(email: user.email)
      customer_id = customer.id
      user.stripe_customer_id = customer_id
      user.save!
      customer_id
    end
  end
end
