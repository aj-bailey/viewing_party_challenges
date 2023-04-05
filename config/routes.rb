Rails.application.routes.draw do
  root "home#index"

  resources :users, only: [:create] do
    resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      resources :viewing_parties, only: [:new, :create]
    end
  end

  get '/register', to: 'users#new'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'
  
  get "/logout", to: "users#logout_user"
  
  get "/dashboard", to: "users#show"
end