Rails.application.routes.draw do
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"

  get "/dashboard", to: "dashboard#index"

  resources :workspaces do
    resources :clients, only: [:index, :show, :create]
  end
end