Rails.application.routes.draw do
  root 'ips#index'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }
  devise_scope :user do
    put 'users/confirmations', to: 'users/confirmations#update'
    get 'users/confirmations/pending', to: 'users/confirmations#pending'
  end

  get '/healthcheck', to: 'monitoring#healthcheck'

  resources :ips, only: [:index, :new, :create, :show]
end
