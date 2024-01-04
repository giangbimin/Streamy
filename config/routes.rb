Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: %i[create]
  get '/signup', to: 'users#new'
  get '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :tickets, only: %i[index new create]
  root "tickets#index"
  resource :carts, only: [] do
    get :show
    post :add
    post :remove
  end
end
