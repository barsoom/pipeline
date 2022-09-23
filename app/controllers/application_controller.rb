class ApplicationController < ActionController::Base
  etag { Rails.application.importmap.digest(resolver: helpers) if request.format&.html? }

  private

  def locals(action = nil, hash)
    render action:, locals: hash
  end
end
