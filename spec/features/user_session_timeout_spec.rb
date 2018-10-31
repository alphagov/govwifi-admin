require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'

describe 'user sessions' do
  context 'when logged out' do
    before { visit root_path }

    it_behaves_like 'not signed in'
  end
end
