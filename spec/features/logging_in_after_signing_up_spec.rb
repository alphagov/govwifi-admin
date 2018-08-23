require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'
require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'logging in after signing up' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  let(:correct_password) { 'f1uffy-bu44ies' }

  before do
    sign_up_for_account(email: 'tom@gov.uk')
    update_user_details(
      password: correct_password,
      confirmed_password: correct_password
    )

    click_on 'Logout'

    fill_in 'Email', with: 'tom@gov.uk'
    fill_in 'Password', with: password

    click_on 'Continue'
  end

  context 'with correct password' do
    let(:password) { correct_password }

    it 'signs me in' do
      expect(page).to have_content 'Logout'
    end
  end

  context 'with incorrect password' do
    let(:password) { 'coarse' }

    it_behaves_like 'not signed in'

    it 'displays an error to the user' do
      expect(page).to have_content 'Invalid Email or password'
    end
  end
end
