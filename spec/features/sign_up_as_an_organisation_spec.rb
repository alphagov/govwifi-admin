require 'nokogiri'
require 'capybara-screenshot/rspec'
require 'features/support/sign_up_helpers'

describe 'Sign up as an organisation' do
  before do
    sign_up_for_account(email: email)
    create_password_for_account
  end

  context 'with a .gov.uk email' do
    let(:email) { 'someone@gov.uk' }

    it 'congratulates me' do
      expect(page).to have_content 'Congratulations!'
    end
  end

  context 'with a other.gov.uk email' do
    let(:email) { 'someone@other.gov.uk' }

    it 'congratulates me' do
      expect(page).to have_content 'Congratulations!'
    end
  end

  context 'with a notgov.uk email' do
    let(:email) { 'someone@notgov.uk' }

    it 'tells me my email is not valid' do
      expect(page).to have_content(
        'only government/whitelisted emails can sign up'
      )
    end
  end

  context 'with a other.notgov.uk email' do
    let(:email) { 'someone@other.notgov.uk' }

    it 'tells me my email is not valid' do
      expect(page).to have_content(
        'only government/whitelisted emails can sign up'
      )
    end
  end
end
