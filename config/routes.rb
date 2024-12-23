require 'sidekiq/web'

Rails.application.routes.draw do
  resources :credit_cards
  # Root Route
  root 'products#index'

  # User Routes
  get '/register', to: 'users#new'
  resources :users, only: [:create, :index, :show] do
    resources :addresses
  end

  # Session Routes
  get '/sign_in', to: 'sessions#new'
  delete '/sign_out', to: 'sessions#destroy'
  resource :sessions, only: [:create]

  # Product Routes
  resources :products

  # Cart Routes
  resource :cart, only: [:show] do
    post 'add', to: 'carts#add', as: 'add_to'
    post 'remove', to: 'carts#remove', as: 'remove_from'
  end  

  post '/select_address', to: 'carts#select_address', as: 'select_address'

  # Orders Routes
  resources :orders, only: [:index, :create, :show]

  # Sidekiq Web UI 
  mount Sidekiq::Web => '/sidekiq'  

  resources :credit_cards

  resources :payments, only: [] do
    collection do
      get :checkout
      get :success
      get :cancel
    end
  end
end
