Rails.application.routes.draw do
  resources :events, only:  %i[index show]
  root "events#index"
  resources :users, only: %i[create]
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :cart_items, only: %i[index create destroy]
  resources :tickets, only: %i[index new create]
  get '/cart', to: 'cart_items#index'
  post "checkout", to: "orders#create"
  get "success", to: "orders#success"
  get "cancel", to: "orders#cancel"
  resources :webhooks, only: [:create]
  get "up" => "rails/health#show", as: :rails_health_check
end
