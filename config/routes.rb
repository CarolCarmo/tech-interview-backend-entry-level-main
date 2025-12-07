require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resources :carts

  # Cart custom routes
  get 'cart', to: 'carts#show'         # Show cart
  post 'cart', to: 'carts#create'      # Create cart
  post 'cart/add_items', to: 'carts#add_items'  # Add items to cart
  delete 'cart/:id', to: 'carts#destroy' # Delete cart

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
