require_relative 'support/not_signed_in'

describe 'logging in after signing up' do
  let(:correct_password) { 'f1uffy-bu44ies' }

  before do
    sign_up_for_account
    create_password_for_account(password: correct_password)

    click_on 'Logout'

    fill_in 'Email', with: 'tom@tom.com'
    fill_in 'Password', with: entered_password

    click_on 'Log in'
  end

  context 'with correct password' do
    let(:entered_password) { correct_password }

    it 'shows me congratulations' do
      expect(page).to have_content 'Congratulations!'
    end
  end

  context 'with incorrect password' do
    let(:entered_password) { 'coarse' }

    it_behaves_like 'not signed in'
  end
end
