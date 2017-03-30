module Authentication
  module OAuth
    module Helpers
      def auth_headers(options = {})
        user = options[:user]
        token = Doorkeeper::AccessToken.create(resource_owner_id: user.id,
                                               expires_in: 1.hour)
        { 'Authorization': "Bearer #{ token.token }" }
      end
    end
  end
end
