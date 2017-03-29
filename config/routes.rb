Rails.application.routes.draw do
  concern :api_base do
    resources :users do
      resources :boards, only: [:index]
    end
    resources :boards
    resources :lists
    resources :cards
    resources :comments
  end

  concern :jwt_authenticated_api do
    concerns :api_base
    post 'user_token' => 'user_token#create'
  end

  subdomain = ENV.fetch('API_SUBDOMAIN', '')
  constraints subdomain: subdomain do
    namespace :v3 do
      concerns :jwt_authenticated_api
    end

    namespace :v2 do
      concerns :api_base
    end

    namespace :v1 do
      concerns :api_base
    end
  end
end
