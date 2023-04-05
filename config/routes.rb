Rails.application.routes.draw do
  root "home#index"

  resources :users, only: [:create] do
    # resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      resources :viewing_parties, only: [:new, :create]
    end
  end

  resources :discover, only: [:index]

  get "/dashboard", to: "users#show"
  get '/register', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get "/logout", to: "sessions#destroy"
end