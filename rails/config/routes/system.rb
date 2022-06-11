
Rails.application.routes.draw do
  get 'healthcheck', to: 'statuses#healthcheck'
  get 'version',     to: 'statuses#version'
  get 'hostname',    to: 'systems#hostname'
  get 'datetime',    to: 'systems#datetime'

  # 本番環境ではnginxをフロントに設置し、basic認証をかけるので、
  # `Rails.env.development?`はコメントアウトしています
  # if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  # end
end
