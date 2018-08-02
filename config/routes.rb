Rails.application.routes.draw do
  root 'example#page'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    put 'users/confirmations', to: 'users/confirmations#update'
    get 'users/confirmations/pending', to: 'users/confirmations#pending'
  end

  get '/healthcheck', to: 'monitoring#healthcheck'
  get '/signup/start', to: 'signups#start'
  get '/signup/organisation', to: 'signups#organisation'
  get '/signup/confirmation', to: 'signups#confirmation'
end
