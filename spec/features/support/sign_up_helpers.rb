def sign_up_for_account(email: 'default@gov.uk')
  visit new_user_registration_path
  fill_in 'user_email', with: email
  click_on 'Sign up'
end

def create_password_for_account(password: 'supersecret')
  return unless confirmation_email_received?
  visit confirmation_email_link
  fill_in 'New password', with: password
  fill_in 'Confirm new password', with: password
  click_on 'Change my password'
end

def confirmation_email_link
  confirmation_email = ActionMailer::Base.deliveries.first
  parsed_email = Nokogiri::HTML(confirmation_email.body.to_s)
  parsed_email.css('a').first['href']
end

def confirmation_email_received?
  ActionMailer::Base.deliveries.any?
end
