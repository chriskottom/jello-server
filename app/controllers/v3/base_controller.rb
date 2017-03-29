class V3::BaseController < ApplicationController
  include Knock::Authenticable

  before_action :authenticate_user

  private

  def unauthorized_entity(entity)
    log_unauthorized_request
    respond_with_unauthorized
  end

  def log_unauthorized_request
    path = request.path
    host = request.ip
    logger.warn "Unauthorized attempt to access #{ path } from #{ host }"
  end
end
