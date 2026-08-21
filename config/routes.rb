Rails.application.routes.draw do
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"

  get "/dashboard", to: "dashboard#index"

  resources :workspaces, only: [ :index, :show, :create, :update, :destroy ] do
  resources :clients, only: [ :index, :show, :create, :update, :destroy ]
end
end
