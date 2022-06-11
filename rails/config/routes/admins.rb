Rails.application.routes.draw do
  namespace :admins do
    root 'home#index'
    get    '/login',   to: "auth/sessions#new"
    post   '/login',   to: "auth/sessions#create"
    delete '/logout',  to: "auth/sessions#destroy"

    resources :app_configs, only: [:index, :edit, :update]
    namespace :auth do
      resource :password_changes, only: [:edit, :update]
      resource :edit_changes, only: [:edit, :update]
    end
    resources :admins
    resources :users do
      resources :discounts, only: [:edit, :update]
    end
  end
end
