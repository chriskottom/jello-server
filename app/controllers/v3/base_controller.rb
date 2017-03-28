class V3::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  if ENV['AUTHORIZED_USERNAME']
    username = ENV['AUTHORIZED_USERNAME']
    password = ENV['AUTHORIZED_PASSWORD']
    http_basic_authenticate_with name: username, password: password
  end
end
