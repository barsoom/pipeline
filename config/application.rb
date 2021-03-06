require File.expand_path("../boot", __FILE__)

require "rails"

# Include each railties manually, excluding `active_storage/engine`
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  require railtie
rescue LoadError
end

Bundler.setup(:default, :assets, Rails.env) if defined?(Bundler)

require "jquery-rails"
require "coffee-rails"
require "sassc-rails"
require "bootstrap-sass"
require "uglifier"
require "attr_extras"
require "slim"
require_relative "../app/middleware/push_backend"

I18n.enforce_available_locales = true

module Pipeline
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/presenters
    )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # ig.i18n.default_locale = :de

    # https://stackoverflow.com/a/57681360
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)

    config.middleware.use PushBackend

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [ :password ]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = "1.0"

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
