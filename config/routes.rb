Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    unlocks: 'users/unlocks'
  }
  devise_scope :user do
    put 'users/confirmations', to: 'users/confirmations#update'
    get 'users/confirmations/pending', to: 'users/confirmations#pending'
  end

  get '/healthcheck', to: 'monitoring#healthcheck'
  resources :status, only: %i[index]
  resources :organisations, only: %i[index]
  resources :ips, only: %i[index new create]
  resources :help, only: %i[index create]
  resources :team_members, only: %i[index]
  resources :logs, only: %i[index] do
    get 'search', on: :collection
  end

  namespace :admins do
    resources :mou, only: %i[index update create]
  end
  namespace :organisations do
    resources :mou, only: %i[index create]
  end
end
