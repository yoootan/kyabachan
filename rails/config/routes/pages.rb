Rails.application.routes.draw do
  namespace :pages do
    root 'home#index'
    get 'privacy', to: "pages#privacy"
    get 'terms',   to: "pages#terms"
    get 'law',     to: "pages#law"
  end
end
