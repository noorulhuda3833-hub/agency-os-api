Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  
  get "/up", to: "health#show"
  
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"
  get "/dashboard", to: "dashboard#index"

  resources :companies, only: [ :index, :create ]

  resources :workspaces, only: [ :index, :show, :create, :update, :destroy ] do
    resources :clients, only: [ :index, :show, :create, :update, :destroy ] do
      resources :notes, only: [ :index, :create, :show, :update, :destroy ]
      resources :briefing_documents, only: [ :index, :create ]
        post :briefing, on: :member
    end
  end
end
