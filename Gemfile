source "https://rubygems.org"

ruby file: ".ruby-version"

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
gem "tzinfo-data"
gem "mutex_m" # Added to avoid: warning: mutex_m was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add mutex_m to your Gemfile or gemspec. Also contact author of activesupport-7.0.8.4 to add mutex_m into its gemspec.
gem "base64" # Added to avoid: warning: base64 was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add base64 to your Gemfile or gemspec. Also contact author of activesupport-7.0.8.4 to add base64 into its gemspec.

# Assets
gem "sassc-rails"
gem "bootstrap-sass"

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

