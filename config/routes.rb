Rails.application.routes.draw do
  root 'home#index'

  get '/setup', to: "home#setup"

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    put 'users/confirmations', to: 'users/confirmations#update'
    get 'users/confirmations/pending', to: 'users/confirmations#pending'
  end

  get '/healthcheck', to: 'monitoring#healthcheck'
  resources :status, only: %i[index]
  resources :ips, only: %i[index new create destroy] do
    get 'remove', to: 'ips#index'
  end
  resources :locations, only: [:new, :create]
  resources :help, only: %i[index create]
  resources :team_members, only: %i[index edit update destroy]
  resources :mou, only: %i[index create]
  resources :logs, only: %i[index] do
    get 'search', on: :collection
  end
  resources :organisations, only: %i[show edit update]

  namespace :admin do
    resources :mou, only: %i[index update create]
    resources :organisations, only: %i[index show destroy]
  end

  %w( 404 422 500 ).each do |code|
    get code, to: 'application#error', code: code
  end
end
