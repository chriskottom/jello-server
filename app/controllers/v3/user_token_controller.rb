class V3::UserTokenController < Knock::AuthTokenController
  include RespondsWithError

  rescue_from Knock.not_found_exception_class_name do |exception|
    respond_with_unauthorized
  end
end
