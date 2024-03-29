require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TicketChallenge
  class Application < Rails::Application
    config.i18n.available_locales = ENV.fetch('AVAILABLE_LOCALES').split(',')

    # eg: DEFAULT_LOCALE = 'en'
    config.i18n.default_locale = ENV.fetch('DEFAULT_LOCALE')

    # eg: FALLBACK_LOCALES = 'en,th'
    # config.i18n.fallbacks = ENV.fetch('FALLBACK_LOCALES').split(',')

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set the queuing backend to `Sidekiq`
    #
    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq

    # Prefix the queue name of all jobs with Rails ENV
    config.active_job.queue_name_prefix = nil

    # Compress the responses to reduce the size of html/json controller responses.
    config.middleware.use Rack::Deflater

    config.generators.system_tests = nil
    config.generators.jbuilder = false
    config.session_store :cookie_store, key: '_ticket_challenge'
  end
end
