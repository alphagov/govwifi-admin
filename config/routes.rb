Rails.application.routes.draw do
  get '/healthcheck', to: 'monitoring#healthcheck'
end
