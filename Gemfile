source "https://rubygems.org"

def on_heroku?
  ENV["DYNO"]
end

ruby "3.1.0"  # NOTE: keep in sync with .circleci/config.yml

gem "rails", "6.1.4.3"

gem "pg"

gem "slim"
gem "attr_extras"
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "faye-websocket"
gem "redis"
gem "puma"
gem "httparty"
gem "barsoom_utils"

# FIXME: net-smtp was removed from ruby standard gems. Remove when https://github.com/mikel/mail/pull/1439 is resolved.
# Also see: https://github.com/rails/rails/pull/42366
gem "net-smtp", require: false

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sassc-rails"
  gem "bootstrap-sass"
  gem "coffee-rails"
  gem "uglifier"
end

group :development, :test do
  gem "rspec-rails"
  gem "rubocop" # See .rubocop.yml for configuration and docs.
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end

gem "jquery-rails"
