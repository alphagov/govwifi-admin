require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'
require 'timecop'

describe 'user sessions timeout' do
  after { Timecop.return }

  context 'when user has not signed in' do
    before { visit root_path }

    it_behaves_like 'not signed in'
  end

  context 'when user has signed in', focus: true do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    before do
      sign_in_user user
      visit root_path
    end

    context 'and they have been inactive for 60 minutes' do
      before do
        Timecop.freeze(Time.now + (60 * 60))
        visit root_path
      end

      it_behaves_like 'not signed in'
    end
  end
end
