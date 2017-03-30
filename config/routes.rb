Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorizations, :authorized_applications
  end

  concern :api_base do
    resources :users do
      resources :boards, only: [:index]
    end
    resources :boards
    resources :lists
    resources :cards
    resources :comments
  end

  subdomain = ENV.fetch('API_SUBDOMAIN', '')
  constraints subdomain: subdomain do
    namespace :v3 do
      concerns :api_base
    end

    namespace :v2 do
      concerns :api_base
    end

    namespace :v1 do
      concerns :api_base
    end
  end
end
