# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :initialize_webhook!

  def create
    stripe_payment_id = @stripe_payment.data.object.id.id
    is_success = @stripe_payment.type == 'checkout.session.completed'
    status = PaymentForm.create(stripe_payment_id: stripe_payment_id, is_success: is_success)
    render json: { message: status ? 'success' : 'failed' }
  end

  private

  def initialize_webhook!
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    @stripe_payment = Stripe::Webhook.construct_event(
      payload, sig_header, Rails.application.credentials[:stripe][:webhook]
    )
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    render json: { message: '404'}
  end
end
