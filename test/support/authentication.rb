module Authentication
  module Basic
    module Helpers
      def auth_headers(options = {})
        username = options.fetch(:username, ENV['AUTHORIZED_USERNAME'])
        password = options.fetch(:password, ENV['AUTHORIZED_PASSWORD'])
        auth = encode_credentials(username, password)
        { 'Authorization' => auth  }
      end

      private

      def encode_credentials(username, password)
        ActionController::HttpAuthentication::Basic.
          encode_credentials(username, password)
      end
    end
  end
end
