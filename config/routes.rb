Rails.application.routes.draw do
  root 'home#new'

  get '/register', to: 'users#new'
  resources :users, only: [:create]

  get '/sign_in', to: 'sessions#new'
  delete '/sign_out', to: 'sessions#destroy'
  resource :sessions, only: [:create]

  resources :users do
    resources :addresses #address show actions
  end

  resources :users, only: [:index, :show]  # Users ke liye index aur show action

  resources :products
  
end
