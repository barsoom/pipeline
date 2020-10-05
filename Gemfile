source "https://rubygems.org"

def on_heroku?
  ENV["DYNO"]
end

ruby "2.7.2"  # NOTE: keep in sync with .circleci/config.yml

# Get rid of "git protocol is insecure" warnings by fetching "github: 'foo/bar'" gems with HTTPS instead.
# Can be removed after bundler 2.0.
# From: https://github.com/bundler/bundler/issues/4978#issuecomment-272248627
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "6.0.3.3"

# Bundle edge Rails instead:
# gem "rails", :git => "git://github.com/rails/rails.git"

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

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem "therubyracer", :platforms => :ruby

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

# To use ActiveModel has_secure_password
# gem "bcrypt-ruby", "~> 3.0.0"

# To use Jbuilder templates for JSON
# gem "jbuilder"

# Use unicorn as the app server
# gem "unicorn"

# Deploy with Capistrano
# gem "capistrano"

# To use debugger
# gem "debugger"
