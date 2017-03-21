Rails.application.routes.draw do
  resources :users
  resources :boards
  resources :lists
  resources :cards
  resources :comments
end
