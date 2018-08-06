require_relative 'support/sign_up_helpers'

describe 'asking users to sign in' do
  shared_examples 'I am not signed in' do
    it 'asks for an email' do
      expect(page).to have_field 'Email'
    end

    it 'asks for a password' do
      expect(page).to have_field 'Password'
    end

    it 'asks me to sign in' do
      expect(page).to have_button 'Log in'
    end
  end

  context 'with no account' do
    context 'when I try to visit the homepage' do
      before { visit '/' }

      it_behaves_like 'I am not signed in'
    end
  end

  context 'with a pre-existing account, but signed out' do
    before do
      sign_up_for_account
      create_password_for_account

      click_on 'Logout'

      visit '/'
    end

    it_behaves_like 'I am not signed in'
  end
end
