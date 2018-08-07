require 'nokogiri'
require 'capybara-screenshot/rspec'
require 'features/support/sign_up_helpers'

describe 'Sign up as an organisation' do
  context 'when entering correct information' do
    it 'congratulates me' do
      sign_up_for_account
      create_password_for_account
      expect(page).to have_content "Congratulations!"
    end
  end

  context 'when password does not match password confirmation' do
    it 'tells me that my passwords do not match' do
      sign_up_for_account
      create_password_for_account(password: "password", confirmed_password: "password1")
      expect(page).to have_content "Set your password"
      expect(page).to have_content "Passwords must match"
    end
  end

  context 'when account is already confirmed' do
    it 'tells me my email is already confirmed' do
      sign_up_for_account
      create_password_for_account
      visit confirmation_email_link
      expect(page).to have_content 'Email was already confirmed'
    end
  end
end
