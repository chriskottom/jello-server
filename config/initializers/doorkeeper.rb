Doorkeeper.configure do
  orm :active_record
  base_controller 'ApplicationController'
  realm "Jello API"
  access_token_expires_in 1.hour

  resource_owner_from_credentials do |routes|
    User.authenticate!(params[:email], params[:password])
  end

  grant_flows []
  use_refresh_token
end

Doorkeeper.configuration.token_grant_types << "password"
