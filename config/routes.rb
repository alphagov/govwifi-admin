Rails.application.routes.draw do
  root 'example#page'

  get '/healthcheck', to: 'monitoring#healthcheck'
  get '/signup/start', to: 'signups#start'
end
