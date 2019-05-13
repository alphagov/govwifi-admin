# rubocop:disable Metrics/BlockLength
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
  resources :status, only: %i[index]
  resources :ips, only: %i[index new create destroy] do
    get 'remove', to: 'ips#index'
    get 'created', to: 'ips#index', on: :collection
    get 'created/location', to: 'ips#index', on: :collection
    get 'created/location/with-ip', to: 'ips#index', on: :collection
    get 'removed', to: 'ips#index', on: :collection
    get 'removed/location', to: 'ips#index', on: :collection
  end

  resources :help, only: %i[create new] do
    get '/', on: :collection, to: 'help#new'
    get 'signed_in', on: :new
    get 'admin_account', on: :new
    get 'technical_support', on: :new
    get 'user_support', on: :new
  end

  resources :locations, only: %i[new create destroy update] do
    get 'remove', to: 'ips#index'
    get 'rotate_key', to: 'ips#index'
  end
  resources :team_members, only: %i[index edit update destroy] do
    collection do
      get 'created/invite', to: 'team_members#index'
      get 'recreated/invite', to: 'team_members#index'
      get 'updated/permissions', to: 'team_members#index'
      get 'removed', to: 'team_members#index'
    end
  end

  get 'change_organisation', to: 'current_organisation#edit'

  resources :mou, only: %i[index create] do
    collection do
      get 'created', to: 'mou#index'
      get 'replaced', to: 'mou#index'
    end
  end
  resources :logs, only: %i[index]

  resources :logs_searches, path: 'logs/search', only: %i[new index create] do
    get 'ip', on: :new
    get 'username', on: :new
    get 'location', on: :new
  end

  resources :organisations, only: %i[edit update]
  resources :setup_instructions, only: %i[index] do
    collection do
      get 'initial', to: 'setup_instructions#index', as: :new_organisation
    end
  end
  resources :overview, only: %i[index]

  namespace :admin do
    resources :govwifi_map, only: %i[index]
    resources :mou, only: %i[index update create]
    resources :organisations, only: %i[index show destroy]
    resource :whitelist, only: %i[new create] do
      scope module: 'whitelists' do
        resources :email_domains, only: %i[index new create destroy]
        resources :organisation_names, only: %i[index create destroy]
      end
    end
  end

  %w(404 422 500).each do |code|
    get code, to: 'application#error', code: code
  end
end
# rubocop:enable Metrics/BlockLength
