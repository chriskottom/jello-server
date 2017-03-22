Rails.application.routes.draw do
  resources :users do
    resources :boards, only: [:index]
  end
  resources :boards
  resources :lists
  resources :cards
  resources :comments
end
