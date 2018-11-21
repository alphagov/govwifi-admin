require 'features/support/sign_up_helpers'
require 'support/notifications_service'

describe 'Invite a team member' do
  include_examples 'notifications service'
  let(:user) { create(:user) }

  before do
    sign_in_user user
  end

  context 'With the .manage_team permission' do
    before do
      user.permission.update!(can_manage_team: true)
      visit team_members_path
    end

    it 'shows the invite team member link' do
      expect(page).to have_link('Invite team member')
    end

    it 'allows visiting the invites page directly' do
      visit new_user_invitation_path
      expect(page.current_path).to eq(new_user_invitation_path)
    end

    it 'allows re-sending invites' do
      create(:user, organisation: user.organisation, invitation_sent_at: Date.today)
      visit team_members_path

      expect(page).to have_button('Resend invite')
    end
  end

  context 'Without the .manage_team permission' do
    before do
      user.permission.update!(can_manage_team: false)
      sign_in_user user
    end

    it 'hides the invite team member link' do
      visit team_members_path

      expect(page).to_not have_link('Invite team member')
    end

    it 'prevents visiting the invites page directly' do
      visit new_user_invitation_path

      expect(page.current_path).to eq(root_path)
    end

    it 'does not allow re-sending invites' do
      create(:user, organisation: user.organisation, invitation_sent_at: Date.today)
      visit team_members_path

      expect(page).to_not have_button('Resend invite')
    end
  end
end
