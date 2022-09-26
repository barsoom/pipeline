require "slim"
require "bootstrap_forms"

class WebController < ApplicationController
  protect_from_forgery

  before_action :require_password
  before_action :setup_menu

  private

  def active_menu_item_name(name)
    @active_menu_item_name = name
  end

  def require_password
    raise "Need WEB_PASSWORD configured in prod." if Rails.env.production? && !ENV["WEB_PASSWORD"]

    if Rails.env.production? && !session[:logged_in] && params[:pw] != ENV["WEB_PASSWORD"]
      render plain: "Authentication missing.", status: 401
    else
      session[:logged_in] = true
    end
  end
end
