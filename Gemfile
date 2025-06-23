source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 7.1.3"  # LOCKED: It's Rails!

gem "attr_extras"
gem "barsoom_utils"
gem "bootstrap-sass" # Assets
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "honeybadger"
gem "httparty"
gem "importmap-rails"
gem "jwt_authentication", github: "barsoom/jwt_authentication"
gem "jwt", "<3" # LOCKED: Remove direct dependency when verified the breaking changes in https://my.diffend.io/gems/jwt/2.10.1/3.0.0
gem "logger" # Ruby 3.5.0 will no longer have this as a part of standard gems. Reason: activesupport 7.1.4
gem "mail"
gem "ostruct" # Ruby 3.5.0 will no longer have this as a part of standard gems. Reason: pry 0.14.2
gem "paper_trail"
gem "pg"
gem "puma"
gem "redis"
gem "sassc-rails" # Assets
gem "slim"
gem "tzinfo-data"

group :development, :test do
  gem "pry"
  gem "rspec-rails"
  gem "rubocop" # See .rubocop.yml for configuration and docs.
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
end
