class AuthenticationMailer < ::Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Rails.application.routes.url_helpers
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'views/users/mailer' # to make sure that your mailer uses the devise views
end
