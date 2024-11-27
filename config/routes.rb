Rails.application.routes.draw do
  root 'products#index'

  get '/register', to: 'users#new'
  resources :users, only: [:create, :index, :show]

  get '/sign_in', to: 'sessions#new'
  delete '/sign_out', to: 'sessions#destroy'
  resource :sessions, only: [:create]

  resources :users do
    resources :addresses #address show actions
  end

  resources :products
  
end
