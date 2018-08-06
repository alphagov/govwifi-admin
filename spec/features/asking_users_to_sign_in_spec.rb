require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'

describe 'asking users to sign in' do
  context 'with no account' do
    context 'when I try to visit the homepage' do
      before { visit '/' }

      it_behaves_like 'not signed in'
    end
  end

  context 'with a pre-existing account, but signed out' do
    before do
      sign_up_for_account
      create_password_for_account

      click_on 'Logout'

      visit '/'
    end

    it_behaves_like 'not signed in'
  end
end
