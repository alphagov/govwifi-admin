require 'features/support/sign_up_helpers'
require 'timecop'

describe 'logout users after specific period of inactivity' do

  context 'when a signed in user has been inactive for an hour' do
    let(:user) { create(:user, :confirmed, :with_organisation) }

    before do
      sign_in_user user
      visit root_path
      Timecop.travel(Time.now + (60 * 60)) { visit root_path }
    end

    it_behaves_like 'not signed in'

    it 'they navigate to a page after signing in again' do
      sign_in_user user
      visit team_members_path
      
      expect(page).to have_content('Invite team member')
    end
  end
end
