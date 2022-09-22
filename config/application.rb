require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
require_relative "../app/middleware/push_backend"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pipeline
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.use PushBackend

    # Enable the asset pipeline
    config.assets.enabled = true

    dev_or_test = Rails.env.test? || Rails.env.development?
    default_key = dev_or_test ? "test" : nil
    config.secret_key_base = ENV["SECRET_KEY_BASE"] || default_key

    unless config.secret_key_base
      puts "You must set SECRET_KEY_BASE. Generate one with 'rake secret'."

      # Don't break in prod, breaks heroku asset precompilation.
      exit 1 if dev_or_test
    end
  end
end
