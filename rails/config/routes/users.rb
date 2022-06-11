Rails.application.routes.draw do
  namespace :users do
    get    '/signup',  to: "auth/registrations#new"
    post   '/signup',  to: "auth/registrations#create"
    get    '/login',   to: "auth/sessions#new"
    post   '/login',   to: "auth/sessions#create"
    delete '/logout',  to: "auth/sessions#destroy"

    namespace :auth do
      resources :registrations, only: [] do
        get :thanks_create, on: :collection
        get :activate
        get :thanks_activate, on: :collection
      end
      resource :password_changes, only: [:edit, :update]
      resources :password_resets, only: [:new, :create, :edit, :update] do
        get :thanks_create, on: :collection
        get :thanks_update, on: :collection
      end
      resource :email_changes, only: [:edit, :update] do
        get :thanks_create, on: :collection
        get :activate
      end
      resource :withdrawals, only: [:destroy]
    end

    resource :me, only: [:show]
    resource :settings, only: [:edit, :update]
  end
end
