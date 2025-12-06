require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  #Cart routes
  post 'cart', to: 'carts#create'
  post 'cart/add_items', to: 'carts#add_item'
  get 'cart', to: 'carts#show'
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
