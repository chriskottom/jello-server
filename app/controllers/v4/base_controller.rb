class V4::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  def doorkeeper_unauthorized_render_options(error: nil)
    message = 'Not authorized to perform requested action'
    if error && error.respond_to?(:description)
      message = error.description
    end

    {
      status: :unauthorized,
      json: {
        error: {
          status: 401,
          name: "Unauthorized",
          message: message
        }
      }
    }
  end
end
