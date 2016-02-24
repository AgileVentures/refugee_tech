Rails.application.routes.draw do
  apipie
  resources :users
  resource :session, only: [:new, :create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show], constraints: { format: /(json)/ }
    end

    namespace :v0 do
      resources :ping, only: [:index], constraints: { format: /(json)/ }
    end

  end
  root to: 'application#welcome'
end