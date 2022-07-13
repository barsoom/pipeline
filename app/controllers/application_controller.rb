class ApplicationController < ActionController::Base
  private

  def locals(action = nil, hash)
    render action:, locals: hash
  end
end
