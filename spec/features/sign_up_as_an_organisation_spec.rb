require 'nokogiri'
require 'capybara-screenshot/rspec'
require 'features/support/sign_up_helpers'

describe 'Sign up as an organisation' do
  context 'with matching passwords' do
    before do
      sign_up_for_account(email: email)
      create_password_for_account
    end

    context 'with a gov.uk email' do
      let(:email) { 'someone@gov.uk' }

      it 'congratulates me' do
        expect(page).to have_content 'Congratulations!'
      end
    end

    context 'with a email from a subdomain of gov.uk' do
      let(:email) { 'someone@other.gov.uk' }

      it 'congratulates me' do
        expect(page).to have_content 'Congratulations!'
      end
    end

    context 'with a notgov.uk email' do
      let(:email) { 'someone@notgov.uk' }

      it 'tells me my email is not valid' do
        expect(page).to have_content(
          'Email must be from a government domain'
        )
      end
    end

    context 'with a blank email' do
      let(:email) { '' }

      it 'tells me my email is not valid' do
        expect(page).to have_content(
          "Email can't be blank"
        )
      end
    end
  end

  context 'with different password and confirmation' do
    before do
      sign_up_for_account
      create_password_for_account(
        password: 'password',
        confirmed_password: 'different'
      )
    end

    it 'tells me that my passwords do not match' do
      expect(page).to have_content 'Set your password'
      expect(page).to have_content 'Passwords must match'
    end
  end

  context 'when trying to register again' do
    before do
      sign_up_for_account
      create_password_for_account
      2.times { visit confirmation_email_link }
    end

    it 'tells me my email is already confirmed' do
      expect(page).to have_content 'Email was already confirmed'
    end
  end
end
