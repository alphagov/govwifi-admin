require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'asking users to sign in' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'with no account' do
    context 'when I try to visit the homepage' do
      before { visit '/' }

      it_behaves_like 'not signed in'
    end
  end

  context 'with a pre-existing account, but signed out' do
    before do
      sign_up_for_account
      update_user_details

      click_on 'Sign out'

      visit '/'
    end

    it_behaves_like 'not signed in'
  end
end
