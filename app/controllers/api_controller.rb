class ApiController < ApplicationController
  before_action :check_token
  skip_before_action :verify_authenticity_token

  def check_token
    render body: nil, status: :unauthorized unless App.api_token == params[:token]
  end
end
