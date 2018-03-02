source "https://rubygems.org"

def on_heroku?
  ENV["DYNO"]
end

ruby "2.5.0"

# Get rid of "git protocol is insecure" warnings by fetching "github: 'foo/bar'" gems with HTTPS instead.
# Can be removed after bundler 2.0.
# From: https://github.com/bundler/bundler/issues/4978#issuecomment-272248627
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 4.2"

# Bundle edge Rails instead:
# gem "rails", :git => "git://github.com/rails/rails.git"

gem "pg"
gem "slim"
gem "attr_extras"
gem "bootstrap_forms", github: "barsoom/bootstrap_forms"
gem "faye-websocket"
gem "redis", "~> 3.2"
gem "thin"
gem "httparty"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails", "~> 4.0.0"
  gem "coffee-rails", "~> 4.0.0"
  gem "bootstrap-sass", "2.1.0.0"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem "therubyracer", :platforms => :ruby

  gem "uglifier", ">= 1.3.0"
end

group :development, :test do
  gem "rspec-rails"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails"
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
