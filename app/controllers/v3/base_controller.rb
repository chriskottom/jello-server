class V3::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    if ENV['AUTHORIZED_USERNAME']
      auth_result = authenticate_with_http_basic do |username, password|
        username == ENV['AUTHORIZED_USERNAME'] &&
          password == ENV['AUTHORIZED_PASSWORD']
      end

      if !auth_result
        respond_with_unauthorized && false
      end
    end
  end

  def respond_with_unauthorized(message = 'HTTP Basic: Access denied.')
    response.headers['WWW-Authenticate'] = "Basic realm=\"Application\""
    render_error :unauthorized,
                 {
                   status: 401,
                   name: "Unauthorized",
                   message: message
                 }
  end
end
