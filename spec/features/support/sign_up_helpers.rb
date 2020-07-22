require "support/confirmation_use_case_spy"
require "warden"

def sign_up_for_account(email: "default@gov.uk")
  visit new_user_registration_path
  fill_in "user_email", with: email
  click_on "Sign up"
end

def update_user_details(
  password: "actually1 strongPassw0rd !!",
  name: "bob",
  service_email: "admin@gov.uk",
  organisation_name: "Org 1",
  two_factor_method: "app"
)
  return unless confirmation_email_received?

  visit confirmation_email_link

  select organisation_name, from: "Organisation name"

  fill_in "Service email", with: service_email
  fill_in "Your name", with: name
  fill_in "Password", with: password
  click_on "Create my account"

  if two_factor_method.nil?
    skip_two_factor_authentication
  else
    complete_two_factor_authentication(two_factor_method)
  end
end

# TODO: Check whether this is still needed
def skip_two_factor_authentication
  Warden.on_next_request do |proxy|
    proxy.session(:user)[two_factor_session_key] = false
  end
end

def complete_two_factor_authentication(two_factor_method)
  totp_double = instance_double(ROTP::TOTP)

  allow(ROTP::TOTP).to receive(:new).and_return(totp_double)
  allow(totp_double).to receive(:verify).and_return(true)
  allow(totp_double).to receive(:provisioning_uri).and_return("some-url")

  choose "app"
  click_on "Continue"

  fill_in :code, with: "999999"
  click_on "Complete setup"
end

def confirmation_email_link
  ConfirmationUseCaseSpy.last_confirmation_url
end

def confirmation_email_received?
  !ConfirmationUseCaseSpy.last_confirmation_url.nil?
end

def sign_in_user(user, pass_through_two_factor: true)
  user.confirm unless user.confirmed?
  login_as(user, scope: :user)

  Warden.on_next_request do |proxy|
    perform_two_factor_auth = proxy.session(:user)[two_factor_session_key] && !pass_through_two_factor
    proxy.session(:user)[two_factor_session_key] = perform_two_factor_auth
  end
end

def two_factor_session_key
  TwoFactorAuthentication::NEED_AUTHENTICATION
end

def sign_out
  click_on "Sign out"
end

def invite_user(email)
  visit new_user_invitation_path
  fill_in "Email", with: email
  click_on "Send invitation email"
end
