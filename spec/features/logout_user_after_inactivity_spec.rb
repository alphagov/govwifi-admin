require 'timecop'

describe 'logout users after specific period of inactivity' do
  let(:user) { create(:user) }

  context 'when a signed in user has been inactive for 59 minutes' do
    before do
      sign_in_user user
      visit root_path
      Timecop.travel(Time.now + 59.minutes) { visit root_path }
    end

    it 'and they navigate to a page' do
      visit settings_path

      expect(page).to have_content('Invite team member')
    end
  end

  context 'when a signed in user has been inactive for an hour' do
    before do
      sign_in_user user
      visit root_path
      Timecop.travel(Time.now + 1.hour) { visit root_path }
    end

    it_behaves_like 'not signed in'

    it 'and they navigate to a page after signing in again' do
      sign_in_user user
      visit settings_path

      expect(page).to have_content('Invite team member')
    end
  end
end
