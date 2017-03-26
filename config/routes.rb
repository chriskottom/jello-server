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

  subdomain = ENV.fetch('API_SUBDOMAIN', '')
  constraints subdomain: subdomain do
    namespace :v1 do
      concerns :api_base
    end
  end
end
