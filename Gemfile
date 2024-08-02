source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 7.1.3"  # LOCKED: It's Rails!

gem "attr_extras"
gem "barsoom_utils"
gem "base64" # Added to avoid: warning: base64 was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add base64 to your Gemfile or gemspec. Also contact author of activesupport-7.0.8.4 to add base64 into its gemspec.
gem "bootstrap-sass" # Assets
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "drb" # Added to avoid warning: drb was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add drb to your Gemfile or gemspec. Also contact author of activesupport-7.0.8.4 to add drb into its gemspec.
gem "honeybadger"
gem "httparty"
gem "importmap-rails"
gem "jwt_authentication", github: "barsoom/jwt_authentication"
gem "mail"
gem "mutex_m" # Added to avoid: warning: mutex_m was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add mutex_m to your Gemfile or gemspec. Also contact author of activesupport-7.0.8.4 to add mutex_m into its gemspec.
gem "pg"
gem "puma"
gem "redis"
gem "sassc-rails" # Assets
gem "slim"
gem "tzinfo-data"

group :development, :test do
  gem "pry"
  gem "rspec-rails"
  gem "rspec_junit_formatter", require: false
  gem "rubocop" # See .rubocop.yml for configuration and docs.
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end
