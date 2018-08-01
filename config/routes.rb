Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'confirmations'
  }
  
  root 'basic#fun'

  get '/signup/start', to: 'signups#start'
  get '/signup/organisation', to: 'signups#organisation'
  get '/signup/confirmation', to: 'signups#confirmation'
end
