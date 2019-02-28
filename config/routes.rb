Rails.application.routes.draw do
  root 'home#index'

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
  resources :health_checks, only: [:index]

  resources :ips, only: %i[index new create destroy] do
    get 'remove', to: 'ips#index'
  end

  resources :help, only: %i[create new] do
    get '/', on: :collection, to: 'help#new'
    get 'signed_in', on: :new
    get 'signing_up', on: :new
    get 'existing_account', on: :new
    get 'feedback', on: :new
  end

  resources :locations, only: %i[new create destroy] do
    get 'remove', to: 'ips#index'
  end
  resources :team_members, only: %i[index edit update destroy]
  resources :mou, only: %i[index create]
  resources :logs, only: %i[index]

  resources :logs_searches, path: 'logs/search', only: %i[new index create] do
    get 'ip', on: :new
    get 'username', on: :new
    get 'location', on: :new
  end

  resources :organisations, only: %i[edit update]
  resources :setup_instructions, only: %i[index]
  resources :overview, only: %i[index]

  namespace :admin do
    resources :mou, only: %i[index update create]
    resources :organisations, only: %i[index show destroy]
    resources :custom_organisations, only: %i[index create destroy]
    resources :authorised_email_domains, only: %i[index new create destroy]
  end

  %w( 404 422 500 ).each do |code|
    get code, to: 'application#error', code: code
  end
end
