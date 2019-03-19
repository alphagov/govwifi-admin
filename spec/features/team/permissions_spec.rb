require 'support/notifications_service'

describe 'Invite a team member' do
  include_context 'with a mocked notifications client'

  let(:user) { create(:user) }

  before { sign_in_user user }

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
      expect(page).to have_current_path(new_user_invitation_path)
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

      expect(page).not_to have_link('Invite team member')
    end

    it 'prevents visiting the invites page directly' do
      visit new_user_invitation_path

      expect(page).to have_current_path(setup_instructions_path)
    end

    it 'does not allow re-sending invites' do
      create(:user, organisation: user.organisation, invitation_sent_at: Date.today)
      visit team_members_path

      expect(page).not_to have_button('Resend invite')
    end
  end
end
