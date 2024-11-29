Rails.application.routes.draw do
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
end
