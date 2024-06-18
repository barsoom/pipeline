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
    # authenticated using jwt_authentication gem
    if ENV["JWT_KEY"] && session[:jwt_user_data]
      session[:logged_in] = true
      return
    end

    raise "Need WEB_PASSWORD configured in prod." if Rails.env.production? && !ENV["WEB_PASSWORD"]

    if ENV["WEB_PASSWORD"] && !session[:logged_in] && params[:pw] != ENV["WEB_PASSWORD"]
      render plain: "Authentication missing.", status: 401
    else
      session[:logged_in] = true
    end
  end
end
