class ApiController < ApplicationController
  before_action :check_token

  def check_token
    render body: nil, status: :unauthorized unless App.api_token == params[:token]
  end
end
