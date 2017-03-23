Rails.application.routes.draw do
  subdomain = ENV.fetch('API_SUBDOMAIN', '')
  constraints subdomain: subdomain do
    scope :v1 do
      resources :users do
        resources :boards, only: [:index]
      end
      resources :boards
      resources :lists
      resources :cards
      resources :comments
    end
  end
end
