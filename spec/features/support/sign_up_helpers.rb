def sign_up_for_account
  visit new_user_registration_path
  fill_in 'user_email', with: 'tom@tom.com'
  click_on 'Sign up'
end

def create_password_for_account(password: 'supersecret', confirmed_password: 'supersecret')
  visit confirmation_email_link
  fill_in 'New password', with: password
  fill_in 'Confirm new password', with: confirmed_password
  click_on 'Save my password'
end

def confirmation_email_link
  confirmation_email = ActionMailer::Base.deliveries.first
  parsed_email = Nokogiri::HTML(confirmation_email.body.to_s)
  parsed_email.css('a').first['href']
end

def sign_in_user(user)
  user.confirm unless user.confirmed?
  login_as(user, scope: :user)
end
