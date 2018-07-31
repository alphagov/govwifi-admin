Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'basic#fun'

  get '/signup/start', to: 'signups#start'
  get '/signup/organisation', to: 'signups#organisation'
  get '/signup/confirmation', to: 'signups#confirmation'
end
