source "https://rubygems.org"

ruby "3.1.2"  # NOTE: keep in sync with .circleci/config.yml

gem "rails", "~> 7.0.4"  # LOCKED: It's Rails!

gem "pg"

gem "slim"
gem "attr_extras"
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "faye-websocket"
gem "redis"
gem "puma"
gem "httparty"
gem "barsoom_utils"
gem "honeybadger"

# FIXME: net-smtp, net-pop and net-imap was removed from ruby standard gems. Remove when https://github.com/mikel/mail/pull/1439 is resolved.
# Also see: https://github.com/rails/rails/pull/42366
gem "net-smtp", require: false
gem "net-pop", require: false
gem "net-imap", require: false

# Assets
gem "sassc-rails"
gem "bootstrap-sass"
gem "terser"

group :development, :test do
  gem "rspec-rails"
  gem "rubocop" # See .rubocop.yml for configuration and docs.
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end

gem "jquery-rails"
