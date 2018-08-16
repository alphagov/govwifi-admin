require 'features/support/sign_up_helpers'
require 'features/support/errors_in_form'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Sign up as an organisation' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'with matching passwords' do
    before do
      sign_up_for_account(email: email)
      create_password_for_account
    end

    context 'with a gov.uk email' do
      let(:email) { 'someone@gov.uk' }

      it 'signs me in' do
        expect(page).to have_content 'Logout'
      end
    end

    context 'with a email from a subdomain of gov.uk' do
      let(:email) { 'someone@other.gov.uk' }

      it 'signs me in' do
        expect(page).to have_content 'Logout'
      end
    end

    context 'with a non-gov email' do
      let(:email) { 'someone@google.com' }

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

  context 'when password does not match password confirmation' do
    before do
      sign_up_for_account
      create_password_for_account(password: 'password', confirmed_password: 'password1')
      expect(page).to have_content 'Set your password'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the passwords do not match' do
      expect(page).to have_content 'Passwords must match'
    end
  end

  context 'when password is too short' do
    before do
      sign_up_for_account
      create_password_for_account(password: '1', confirmed_password: '1')
      expect(page).to have_content 'Set your password'
    end

    it_behaves_like 'errors in form'

    it 'tells the user that the password is too short' do
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end

  context 'when account is already confirmed' do
    before do
      expect_any_instance_of(NotifySupportOfNewUser).to \
        receive(:execute)

      sign_up_for_account
      create_password_for_account
      visit confirmation_email_link
    end

    it_behaves_like 'errors in form'

    it 'tells the user the email is already confirmed' do
      expect(page).to have_content 'Email was already confirmed'
    end
  end

  context 'when making two errors in a row' do
    before do
      sign_up_for_account
      create_password_for_account(password: '1', confirmed_password: '1')
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
      expect(page).to have_content 'Set your password'

      fill_in 'New password', with: "password"
      fill_in 'Confirm new password', with: "password1"
      click_on 'Save my password'
    end

    it_behaves_like 'errors in form'

    it 'correctly sets the second error' do
      expect(page).to have_content 'Passwords must match'
    end
  end
end
