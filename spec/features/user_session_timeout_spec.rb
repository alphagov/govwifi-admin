require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'
require 'timecop'

describe 'user sessions timeout ', focus: true do
  after { Timecop.return }

  let(:user) { create(:user, :confirmed, :with_organisation) }
  context 'when logged out' do
    before { visit root_path }

    it_behaves_like 'not signed in'
  end

  context 'when user is signed in' do
    context 'and they are inactive for 30 minutes' do
      before do 
        sign_in_user user
        visit root_path
        Timecop.freeze(Time.now + (30 * 60))
      end
    end

    it 'will log the user out' do
      it_behaves_like 'not signed in'
    end
    
  end
end
