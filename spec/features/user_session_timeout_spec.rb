require 'features/support/sign_up_helpers'
require 'features/support/not_signed_in'
require 'timecop'

describe 'logout users after specific period of inactivity' do

  context 'when user has not signed in' do
    before { visit root_path }

    it_behaves_like 'not signed in'
  end

  context 'when user has signed in' do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    before do
      sign_in_user user
      visit root_path
    end

    context 'and they have been inactive for 60 minutes' do
      before { Timecop.travel(Time.now + (60 * 60)) { visit root_path } }

      it_behaves_like 'not signed in'

      it 'and they navigate to a page' do
        sign_in_user user

        visit team_members_path
        expect(page).to have_content('Invite team member')
      end
    end
  end
end
