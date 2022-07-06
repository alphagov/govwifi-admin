Rails.application.routes.draw do
  root "home#index"

  devise_for :users,
             controllers: {
               confirmations: "users/confirmations",
               registrations: "users/registrations",
               invitations: "users/invitations",
               passwords: "users/passwords",
               two_factor_authentication: "users/two_factor_authentication",
             }

  devise_scope :user do
    put "users/confirmations", to: "users/confirmations#update"
    get "users/confirmations/pending", to: "users/confirmations#pending"

    put "users/two_factor_authentication_setup", to: "users/two_factor_authentication_setup#update"
    get "users/two_factor_authentication_setup", to: "users/two_factor_authentication_setup#show"

    get "users/:id/two_factor_authentication/edit", to: "users/two_factor_authentication#edit"
    delete "users/:id/two_factor_authentication", to: "users/two_factor_authentication#destroy"
  end
  get "confirm_new_membership", to: "users/memberships#create"

  get "/healthcheck", to: "monitoring#healthcheck"
  get "change_organisation", to: "current_organisation#edit"
  patch "change_organisation", to: "current_organisation#update"

  resources :status, only: %i[index]
  resources :ips, only: %i[index new create destroy]

  resources :help, only: %i[create new] do
    get "/", on: :collection, to: "help#new"
    get "signed_in", on: :new
    get "admin_account", on: :new
    get "technical_support", on: :new
    get "user_support", on: :new
  end
  resources :locations, only: %i[new create destroy update] do
    get "add_ips", to: "add_ips"
    patch "update_ips", to: "update_ips"
  end
  resources :memberships, only: %i[edit update index destroy]
  resources :mou, only: %i[index create]
  resources :logs, only: %i[index]
  resources :logs_searches, path: "logs/search", only: %i[new index create]
  resources :organisations, only: %i[new create edit update]
  resources :settings, only: %i[index] do
    collection do
      get "initial", to: "settings#index", as: :new_organisation
    end
  end
  get "setup_instructions", to: redirect("settings")
  get "setup_instructions/:path", to: redirect("settings/%{path}")

  namespace :super_admin do
    resources :locations, only: %i[index] do
      collection do
        get "map", to: "locations/map#index"
      end
    end
    resources :users, only: %i[index new create] do
      get "remove", to: "users#confirm_remove"
      post "remove", to: "users#remove"
    end
    resources :mou, only: %i[index update create]
    resources :organisations, only: %i[index show destroy] do
      collection do
        get "service_emails", to: "organisations#service_emails", constraints: { format: "csv" }
      end
    end
    resource :allowlist, only: %i[new create] do
      scope module: "allowlists" do
        resources :email_domains, only: %i[index new create destroy]
        resources :organisation_names, only: %i[index create destroy]
      end
    end
    resource :wifi_user_search, only: %i[show create destroy] do
      get "destroy", to: "wifi_user_searches#confirm_destroy", as: :confirm_destroy
    end
  end

  %w[404 422 500].each do |code|
    get code, to: "application#error", code:
  end
end
