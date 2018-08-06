require 'nokogiri'
require 'capybara-screenshot/rspec'
require 'features/support/sign_up_helpers'

describe 'Sign up as an organisation' do
  it 'congratulates me' do
    sign_up_for_account
    create_password_for_account
    expect(page).to have_content "Congratulations!"
  end
end
