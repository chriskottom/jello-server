module Authentication
  module JWT
    module Helpers
      def auth_headers(options = {})
        user = options[:user] || users(:admin)
        token = Knock::AuthToken.new(payload: { sub: user.id }).token
        { 'Authorization': "Bearer #{ token }" }
      end
    end
  end
end
