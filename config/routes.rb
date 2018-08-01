Rails.application.routes.draw do
  root 'example#page'

  devise_for :users

  get '/healthcheck', to: 'monitoring#healthcheck'
  get '/signup/start', to: 'signups#start'
  get '/signup/organisation', to: 'signups#organisation'
  get '/signup/confirmation', to: 'signups#confirmation'
end
