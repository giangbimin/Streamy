# frozen_string_literal: true

if Rails.application.credentials[:stripe].present? && Rails.application.credentials[:stripe][:secret].present?
  Stripe.api_key = Rails.application.credentials[:stripe][:secret]
else
  Stripe.api_key = ENV.fetch('STRIPE_API_KEY')
end
