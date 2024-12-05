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

  # Cart Routes
  resource :cart, only: [:show] do
    post 'add', to: 'carts#add', as: 'add_to'
    post 'add_to_cart', to: 'products#add_to_cart', as: 'add_to_cart'

    post 'remove', to: 'carts#remove', as: 'remove_from'
    get 'checkout', to: 'carts#checkout', as: 'checkout'
  end  
end
