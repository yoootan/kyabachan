Rails.application.routes.draw do
  draw :users
  draw :admins
  draw :pages
  draw :system
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
