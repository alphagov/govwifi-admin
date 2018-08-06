require 'nokogiri'
require 'capybara-screenshot/rspec'

describe 'Signing up' do
  describe 'as an Organisation' do
    it 'congratulates me' do
      visit sign_up_path
      fill_in 'user_email', with: 'tom@tom.com'
      click_on 'Sign up'

      visit confirmation_email_link

      fill_in 'New password', with: 'supersecret'
      fill_in 'Confirm new password', with: 'supersecret'
      click_on 'Change my password'

      expect(page).to have_content "Congratulations!"
    end
  end

  def sign_up_path
    '/users/sign_up'
  end

  def confirmation_email_link
    confirmation_email = ActionMailer::Base.deliveries.first
    parsed_email = Nokogiri::HTML(confirmation_email.body.to_s)
    parsed_email.css('a').first['href']
  end
end
