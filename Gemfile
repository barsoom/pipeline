source "https://rubygems.org"

def on_heroku?
  ENV["DYNO"]
end

ruby "2.7.2"  # NOTE: keep in sync with .circleci/config.yml

gem "rails", "6.0.3.4"

gem "pg"

gem "slim"
gem "attr_extras"
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "faye-websocket"
gem "redis"
gem "puma"
gem "httparty"

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
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end

group :production do
  gem "rails_12factor"
end

gem "jquery-rails"
