source "https://rubygems.org"

ruby "3.2.1"  # NOTE: keep in sync with .circleci/config.yml

gem "rails", "~> 7.0.4"  # LOCKED: It's Rails!

gem "pg"

gem "slim"
gem "attr_extras"
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "redis"
gem "puma"
gem "httparty"
gem "barsoom_utils"
gem "honeybadger"
gem "importmap-rails"
gem "mail", ">= 2.8.0.rc1"

# Assets
gem "sassc-rails"
gem "bootstrap-sass"
gem "terser"

group :development, :test do
  gem "pry"
  gem "rspec-rails"
  gem "rubocop" # See .rubocop.yml for configuration and docs.
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end
